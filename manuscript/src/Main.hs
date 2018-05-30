{-# language OverloadedStrings #-}
{-# language ScopedTypeVariables #-}
module Main where

import Control.Exception
import Data.Version (showVersion)
import Data.Text(Text)
import Paths_manuscript (version)
import Prelude hiding (FilePath)
import Safe (readMay)
import System.Exit (exitSuccess)
import Turtle
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Network.Wreq as Wreq

--import Debug.Trace

import Language.Lua as Lua

data Conf
  = IEEE
  | LLNCS
  deriving (Show)

data DocumentType
  = PostGrad Text Text
  | Paper Conf
  deriving (Show)


documentTemplate :: DocumentType -> FilePath
documentTemplate doc =
  case doc of
    PostGrad _ _   -> "./postgrad_template"
    Paper IEEE  -> "./conf_ieee_template"
    Paper LLNCS -> "./conf_llncs_template"

main :: IO ()
main =
  join (options "Manuscript document builder" parser)

documentType :: IO (Maybe DocumentType)
documentType = do
  p <- Lua.parseFile "config.lua"
  case p of
    Left _ -> do putStrLn "Error"
                 pure Nothing
    Right (Block stat _) -> pure $ extractPostGradData stat <|> extractPaperData stat


extractPaperData :: [Stat] -> Maybe DocumentType
extractPaperData stat =
  Paper <$> lookupPaper stat
  where
    lookupPaper [] = Nothing
    lookupPaper (x:xs) =
      case x of
        Assign [VarName (Name "document")] [PrefixExp (PEVar (SelectName (PEVar (VarName (Name "article"))) (Name "ieee")))] -> Just IEEE
        Assign [VarName (Name "document")] [PrefixExp (PEVar (SelectName (PEVar (VarName (Name "article"))) (Name "llncs")))] -> Just LLNCS
        _ -> lookupPaper xs


extractPostGradData :: [Stat] -> Maybe DocumentType
extractPostGradData stat = do
  doc <- lookupDoc stat
  lookupManuscript doc stat
  where
    lookupDoc [] = Nothing
    lookupDoc (x:xs) =
      case x of
        Assign [VarName (Name "document")] (PrefixExp (PEVar selection) : _) ->
          Just selection
        _ -> lookupDoc xs

    lookupManuscript var stat =
      case var of
        SelectName (PEVar a) b -> lookupTable a b stat
        _ -> Nothing

    lookupTable _ _ [] = Nothing
    lookupTable k v (x:xs) =
      case x of
        Assign [k2] [TableConst v2]
          | k == k2 -> lookupTableValue v v2
          | otherwise -> lookupTable k v xs
        _ -> lookupTable k v xs

    lookupTableValue _ [] = Nothing
    lookupTableValue target (x:xs) =
      case x of
        NamedField a (TableConst d) -> if a == target then buildDocumentType d else Nothing
        _ -> lookupTableValue target xs

buildDocumentType :: [TableField] -> Maybe DocumentType
buildDocumentType exps =
  PostGrad <$> lookupName "degree_name" exps <*> lookupName "document" exps
  where
    lookupName target list =
      case list of
        [] -> Nothing
        (NamedField (Name name) (String value) : xs) -> if name == target then Just value else lookupName target xs

build :: IO ()
build = do
  echo "Building document..."
  d <- documentType
  case d of
    Nothing -> putStrLn "Document type not defined. Is the config file correct?"
    Just doc -> do
      cd (documentTemplate doc)
      current <- pwd
      result <- proc "latexmk" ["-g", "-jobname=document"] ""
      case result of
        ExitSuccess -> pure ()
        ExitFailure _ -> putStrLn "document.pdf not produced -> See log for errors in the document creation"

clean :: IO ()
clean = do
  echo "Cleaning compilation files..."
  d <- documentType
  case d of
    Nothing -> putStrLn "Document type not defined. Is the config file correct?"
    Just doc -> do
      cd (documentTemplate doc)
      current <- pwd
      result <- proc "latexmk" ["-c", "-jobname=document"] ""
      case result of
        ExitSuccess -> echo "Cleaned."
        ExitFailure _ -> echo "Error, see log for errors"


parseBuild :: Parser (IO ())
parseBuild = subcommand "build" "Build the defined meanuscript" (pure build)

parseClean :: Parser (IO ())
parseClean = subcommand "clean" "Clean all document temporary files" (pure clean)

parser :: Parser (IO ())
parser = parseBuild <|> parseVersion <|> parseClean

verboseVersion :: IO ()
verboseVersion =
  putStrLn (showVersion version)

parseVersion :: Parser (IO ())
parseVersion =
  subcommand "version" "Display version information" (pure verboseVersion)


-- Download updates
update :: IO ()
update =
  undefined
