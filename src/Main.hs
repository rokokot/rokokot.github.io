{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.Monoid ()
import           Hakyll

main :: IO ()
main = hakyll $ do
    match ("site/images/*" .||. "site/files/*" .||. "site/static/*/*") $ do
        route   (gsubRoute "site/" (const ""))
        compile copyFileCompiler

    match "site/css/*" $ do
        route   (gsubRoute "site/" (const ""))
        compile compressCssCompiler

    match "site/js/*" $ do
        route   (gsubRoute "site/" (const ""))
        compile copyFileCompiler

    match "site/templates/*" $ compile templateBodyCompiler

    match ("site/projects/*" .&&. complement "site/projects/TEMPLATE.md") $ version "meta" $ do
        compile getResourceBody

    match (fromList ["site/index.md", "site/about.md", "site/research.md", "site/contact.md"]) $ do
        route   $ gsubRoute "site/" (const "") `composeRoutes` setExtension "html"
        compile $ do
            projects <- loadAll ("site/projects/*" .&&. hasVersion "meta")
            let pageCtx = 
                    listField "projects" siteCtx (return projects) `mappend`
                    siteCtx
            pandocCompiler
                >>= loadAndApplyTemplate "site/templates/default.html" pageCtx
                >>= relativizeUrls

    match ("site/projects/*" .&&. complement "site/projects/TEMPLATE.md") $ do
        route $ gsubRoute "site/" (const "projects/") `composeRoutes` setExtension "html"
        compile $ do
            projects <- loadAll ("site/projects/*" .&&. hasVersion "meta")
            let projCtx = 
                    listField "projects" siteCtx (return projects) `mappend`
                    siteCtx
            pandocCompiler
                >>= loadAndApplyTemplate "site/templates/project.html" projCtx
                >>= loadAndApplyTemplate "site/templates/default.html" projCtx
                >>= relativizeUrls

    create ["projects.html"] $ do
        route idRoute
        compile $ do
            projects <- loadAll ("site/projects/*" .&&. hasVersion "meta")
            let projectsCtx =
                    listField "projects" siteCtx (return projects) `mappend`
                    constField "title" "Projects" `mappend`
                    siteCtx
            makeItem ""
                >>= loadAndApplyTemplate "site/templates/projects-list.html" projectsCtx
                >>= loadAndApplyTemplate "site/templates/default.html" projectsCtx
                >>= relativizeUrls

siteCtx :: Context String
siteCtx =
    constField "site_name" "Robin Kokot" `mappend`
    constField "university" "KU Leuven" `mappend`
    constField "department" "Faculty of Engineering Science" `mappend`
    constField "email" "robin.edu.hr@gmail.edu" `mappend`
    constField "github_username" "rokokot" `mappend`
    defaultContext