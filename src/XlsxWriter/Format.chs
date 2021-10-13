{-# LANGUAGE ForeignFunctionInterface #-}
-- | https://libxlsxwriter.github.io/format_8h.html
module XlsxWriter.Format where

#include <stdio.h>
#include "xlsxwriter/format.h"

import Foreign.C
import Data.ByteString

data Format_struct
{#pointer *lxw_format as Format -> Format_struct #}

{#enum lxw_format_alignments as FormatAlignment {underscoreToCase} deriving (Show, Eq) #}

{#enum lxw_format_underlines as FormatUnderline {underscoreToCase} deriving (Show, Eq) #}

{#enum lxw_format_scripts as FormatScript {underscoreToCase} deriving (Show, Eq) #}

{#enum lxw_format_diagonal_types as FormatDiagonal {underscoreToCase} deriving (Show, Eq) #}

{#enum lxw_defined_colors as FormatDefinedColor {underscoreToCase} deriving (Show, Eq) #}

{#enum lxw_format_patterns as FormatPattern {underscoreToCase} deriving (Show, Eq) #}

{#enum lxw_format_borders as FormatBorder {underscoreToCase} deriving (Show, Eq) #}

{#fun unsafe format_set_hidden
  { id `Format' } -> `()' #}

{#fun unsafe format_set_unlocked
  { id `Format' } -> `()' #}

{#fun unsafe format_set_num_format
  { id `Format', useAsCString* `ByteString' } -> `()' #}

{#fun unsafe format_set_num_format_index
  { id `Format', `Int' } -> `()' #}

{#fun unsafe format_set_align { id `Format', `FormatAlignment' } -> `()' #}

-- Fonts
{#fun unsafe format_set_font_name { id `Format', useAsCString* `ByteString' } -> `()' #}
{#fun unsafe format_set_font_size { id `Format', `Double' } -> `()' #}
{#fun unsafe format_set_font_color { id `Format', `FormatDefinedColor' } -> `()' #}
{#fun unsafe format_set_bold { id `Format' } -> `()' #}
{#fun unsafe format_set_italic { id `Format' } -> `()' #}
{#fun unsafe format_set_underline { id `Format', `FormatUnderline' } -> `()' #}
{#fun unsafe format_set_font_strikeout { id `Format' } -> `()' #}
{#fun unsafe format_set_font_script { id `Format', `FormatScript' } -> `()' #}

{#fun unsafe format_set_text_wrap { id `Format' } -> `()' #}

{#fun unsafe format_set_pattern { id `Format', `FormatPattern' } -> `()' #}
{#fun unsafe format_set_bg_color { id `Format', `FormatDefinedColor' } -> `()' #}
{#fun unsafe format_set_fg_color { id `Format', `FormatDefinedColor' } -> `()' #}

-- Borders, etc
{#fun unsafe format_set_border { id `Format', `FormatBorder' } -> `()' #}
{#fun unsafe format_set_bottom { id `Format', `FormatBorder' } -> `()' #}
{#fun unsafe format_set_top { id `Format', `FormatBorder' } -> `()' #}
{#fun unsafe format_set_left { id `Format', `FormatBorder' } -> `()' #}
{#fun unsafe format_set_right { id `Format', `FormatBorder' } -> `()' #}
{#fun unsafe format_set_border_color { id `Format', `FormatDefinedColor' } -> `()' #}
{#fun unsafe format_set_top_color { id `Format', `FormatDefinedColor' } -> `()' #}
{#fun unsafe format_set_left_color { id `Format', `FormatDefinedColor' } -> `()' #}
{#fun unsafe format_set_right_color { id `Format', `FormatDefinedColor' } -> `()' #}
