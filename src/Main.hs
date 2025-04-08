{-# LANGUAGE OverloadedStrings #-}


module Main where

import           Data.Monoid ()
import           Hakyll

main :: IO ()
main = hakyll $ do
    match ("images/*" .||. "files/*" .||. "static/*/*") $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "templates/*" $ compile templateBodyCompiler

    match (fromList ["index.md", "about.md", "research.md", "contact.md"]) $ do
        route   $ setExtension "html"
        compile $ do
            projects <- loadAll "projects/*"
            let pageCtx = 
                    listField "projects" siteCtx (return projects) `mappend`
                    siteCtx
            pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" pageCtx
                >>= relativizeUrls

    match "projects/*" $ do
        route $ setExtension "html"
        compile $ do
            projects <- loadAll "projects/*"
            let projCtx = 
                    listField "projects" siteCtx (return projects) `mappend`
                    siteCtx
            pandocCompiler
                >>= loadAndApplyTemplate "templates/project.html" projCtx
                >>= loadAndApplyTemplate "templates/default.html" projCtx
                >>= relativizeUrls
                
    match "js/*" $ do
        route idRoute
        compile copyFileCompiler


    create ["projects.html"] $ do
        route idRoute
        compile $ do
            projects <- loadAll "projects/*"
            let projectsCtx =
                    listField "projects" siteCtx (return projects) `mappend`
                    constField "title" "Projects" `mappend`
                    siteCtx
            makeItem ""
                >>= loadAndApplyTemplate "templates/projects-list.html" projectsCtx
                >>= loadAndApplyTemplate "templates/default.html" projectsCtx
                >>= relativizeUrls

siteCtx :: Context String
siteCtx =
    constField "site_name" "Robin Kokot" `mappend`
    constField "university" "KU Leuven" `mappend`
    constField "email" "robin.edu.hr@gmail.edu" `mappend`
    constField "github_username" "rokokot" `mappend`
    defaultContext