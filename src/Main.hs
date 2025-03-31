{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Hakyll

-- Main Site Generation
main :: IO ()
main = hakyll $ do
    -- Static Files
    match ("images/*" .||. "files/*") $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Templates
    match "templates/*" $ compile templateBodyCompiler

    -- Pages
    match (fromList ["index.md", "about.md", "research.md", "projects.md", "contact.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" siteCtx
            >>= relativizeUrls

    -- Projects
    match "projects/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/project.html" siteCtx
            >>= loadAndApplyTemplate "templates/default.html" siteCtx
            >>= relativizeUrls

    -- Create Projects Index
    create ["projects.html"] $ do
        route idRoute
        compile $ do
            projects <- loadAll "projects/*"
            let projectsCtx =
                    listField "projects" siteCtx (return projects) `mappend`
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/projects-list.html" projectsCtx
                >>= loadAndApplyTemplate "templates/default.html" projectsCtx
                >>= relativizeUrls

-- Site-wide Context with Custom Metadata
siteCtx :: Context String
siteCtx =
    constField "site_name" "Robin Kokot" `mappend`
    defaultContext