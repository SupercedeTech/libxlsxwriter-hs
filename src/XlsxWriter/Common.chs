{-# LANGUAGE ForeignFunctionInterface #-}
-- | https://libxlsxwriter.github.io/common_8h.html
module XlsxWriter.Common where

#include <stdint.h>
#include "xlsxwriter/common.h"

import Foreign
import Foreign.C
import Control.Monad (liftM)

type Row = {#type lxw_row_t #}
--{#typedef lxw_row_t Row #}
--{#default in `Row' [lxw_row_t] fromIntegral #}

type Col = {#type lxw_col_t #}

{--
-- TODO: do we need this?
{#enum lxw_boolean as LxwBoolean {underscoreToCase} deriving (Show, Eq) #}
{#typedef lxw_boolean LxwBoolean #}
{#default in ` #}
--}

data DateTime = DateTime
  { dtYear :: Int,
    dtMonth :: Int,
    dtDay :: Int,
    dtHour :: Int,
    dtMin :: Int,
    dtSec :: Double
  } deriving Show

instance Storable DateTime where
  sizeOf _ = {#sizeof lxw_datetime #}
  alignment _ = {#alignof lxw_datetime #}
  peek p = DateTime
           <$> liftM fromIntegral ({#get lxw_datetime->year #} p)
           <*> liftM fromIntegral ({#get lxw_datetime->month #} p)
           <*> liftM fromIntegral ({#get lxw_datetime->day #} p)
           <*> liftM fromIntegral ({#get lxw_datetime->hour #} p)
           <*> liftM fromIntegral ({#get lxw_datetime->min #} p)
           <*> ({#get lxw_datetime->sec #} p >>= \(CDouble dbl) -> pure dbl)
  poke p x = do
    {#set lxw_datetime.year #} p (fromIntegral $ dtYear x)
    {#set lxw_datetime.month #} p (fromIntegral $ dtMonth x)
    {#set lxw_datetime.day #} p (fromIntegral $ dtDay x)
    {#set lxw_datetime.hour #} p (fromIntegral $ dtHour x)
    {#set lxw_datetime.min #} p (fromIntegral $ dtMin x)
    {#set lxw_datetime.sec #} p (CDouble $ dtSec x)

{#pointer *lxw_datetime as DateTimePtr -> DateTime #}

{#enum lxw_error as Error {underscoreToCase} deriving (Show, Eq) #}
{#typedef lxw_error Error #}
