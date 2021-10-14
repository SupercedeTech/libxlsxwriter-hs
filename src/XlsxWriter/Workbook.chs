{-# LANGUAGE ForeignFunctionInterface #-}
-- | https://libxlsxwriter.github.io/workbook_8h.html
module XlsxWriter.Workbook where

#include "xlsxwriter/workbook.h"

import Data.Foldable
import Foreign
import Foreign.C
import Data.ByteString
{#import XlsxWriter.Common #}
{#import XlsxWriter.Format #}
import XlsxWriter.Worksheet

{#context lib="xlsxwriter" #}

-- these structs are only used via opaque pointers, so we follow the
-- convention of giving naming priority to the generated pointer
-- rather than the struct value (i.e. Workbook, not WorkbookPtr)
data Workbook_struct
{#pointer *lxw_workbook as Workbook -> Workbook_struct #}

data WorkbookOptions = WorkbookOptions
  { woConstantMemory :: Bool,
    woTmpdir :: Maybe ByteString,
    woUseZip64 :: Bool
  }
  deriving (Show)

instance Storable WorkbookOptions where
  sizeOf _ = {#sizeof lxw_workbook_options #}
  alignment _ = {#alignof lxw_workbook_options #}
  peek p = do
    constMem <- (/= 0) <$> {#get lxw_workbook_options->constant_memory #} p
    tmpdir <-
      {#get lxw_workbook_options->tmpdir #} p
      >>= \ptr -> if ptr == nullPtr then pure Nothing else (Just <$> packCString ptr)
    useZip64 <- (/= 0) <$> {#get lxw_workbook_options->use_zip64 #} p
    pure $ WorkbookOptions constMem tmpdir useZip64
  poke p x = do
    {#set lxw_workbook_options.constant_memory #} p $
      if woConstantMemory x then 1 else 0
    for_ (woTmpdir x) $ \dir -> useAsCString dir $ \cstr ->
      {#set lxw_workbook_options.tmpdir #} p cstr
    {#set lxw_workbook_options.use_zip64 #} p $
      if woUseZip64 x then 1 else 0

{#pointer *lxw_workbook_options as WorkbookOptionsPtr -> WorkbookOptions #}

{#fun unsafe workbook_new
 { useAsCString* `ByteString' } -> `Workbook' #}

{#fun unsafe workbook_new_opt
  { useAsCString* `ByteString', with* `WorkbookOptions' } -> `Workbook' #}

-- Writing this one manually because importing certain aspects of
-- Worksheet triggers unclear c2hs bugs:
-- https://github.com/haskell/c2hs/issues/189
workbook_add_worksheet :: Workbook -> ByteString -> IO Worksheet
workbook_add_worksheet wb name = do
  useAsCString name $ workbook_add_worksheet'_ wb

foreign import ccall unsafe "XlsxWriter/Workbook.chs.h workbook_add_worksheet"
  workbook_add_worksheet'_ :: Workbook -> Ptr CChar -> IO Worksheet

{#fun unsafe workbook_add_format { id `Workbook' } -> `Format' id #}

{#fun unsafe workbook_close { id `Workbook' } -> `Error' #}
