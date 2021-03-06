" Vim syntax file
" Language: swift
" Original Maintainer: Joe Groff <jgroff@apple.com>
" Last Change: 2017 Aug 16
" Modifications copyright (C) 2017 Brian Heim

if exists("b:current_syntax")
    finish
endif

" TODO: redo keyword/punctuation rules based on https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html
" add # to iskeyword (see :syn-iskeyword)

" keywords can have alphanumerics, _, #
" see isfname for format
syn iskeyword 48-57,a-z,A-Z,#,_

syn keyword swiftKeyword
    \ associatedtype
    \ break
    \ case
    \ catch
    \ continue
    \ default
    \ defer
    \ do
    \ else
    \ fallthrough
    \ for
    \ guard
    \ if
    \ in
    \ repeat
    \ return
    \ switch
    \ throw
    \ try
    \ where
    \ while
syn match swiftMultiwordKeyword
    \ "indirect case"

syn keyword swiftImport skipwhite nextgroup=swiftImportModule
    \ import

syn keyword swiftDefinitionModifier
    \ convenience
    \ dynamic
    \ fileprivate
    \ final
    \ internal
    \ nonmutating
    \ open
    \ override
    \ private
    \ public
    \ required
    \ rethrows
    \ static
    \ throws
    \ weak

syn keyword swiftInOutKeyword skipwhite nextgroup=swiftTypeName
    \ inout

syn keyword swiftIdentifierKeyword
    \ Self
    \ metatype
    \ self
    \ super

syn keyword swiftFuncKeywordGeneral skipwhite nextgroup=swiftTypeParameters
    \ init

syn keyword swiftFuncKeyword
    \ deinit
    \ subscript

syn keyword swiftScope
    \ autoreleasepool

syn keyword swiftMutating skipwhite nextgroup=swiftFuncDefinition
    \ mutating
syn keyword swiftFuncDefinition skipwhite nextgroup=swiftTypeName,swiftOperator
    \ func

syn keyword swiftTypeDefinition skipwhite nextgroup=swiftTypeName
    \ class
    \ enum
    \ extension
    \ protocol
    \ struct
    \ typealias
syn match swiftMultiwordTypeDefinition skipwhite nextgroup=swiftTypeName
    \ "indirect enum"

syn keyword swiftVarDefinition skipwhite nextgroup=swiftVarName
    \ let
    \ var

syn keyword swiftLabel
    \ get
    \ set
    \ didSet
    \ willSet

syn keyword swiftBoolean
    \ false
    \ true

syn keyword swiftNil
    \ nil

syn match swiftImportModule contained nextgroup=swiftImportComponent
    \ /\<[A-Za-z_][A-Za-z_0-9]*\>/
syn match swiftImportComponent contained nextgroup=swiftImportComponent
    \ /\.\<[A-Za-z_][A-Za-z_0-9]*\>/

syn match swiftTypeName contained skipwhite nextgroup=swiftTypeParameters
    \ /\<[A-Za-z_][A-Za-z_0-9\.]*\>/
syn match swiftVarName contained skipwhite nextgroup=swiftTypeDeclaration
    \ /\<[A-Za-z_][A-Za-z_0-9]*\>/
syn match swiftImplicitVarName
    \ /\$\<[A-Za-z_0-9]\+\>/

" TypeName[Optionality]?
syn match swiftType contained skipwhite nextgroup=swiftTypeParameters
    \ /\<[A-Za-z_][A-Za-z_0-9\.]*\>[!?]\?/
" [Type:Type] (dictionary) or [Type] (array)
syn region swiftType contained contains=swiftTypePair,swiftType
    \ matchgroup=Delimiter start=/\[/ end=/\]/
syn match swiftTypePair contained skipwhite nextgroup=swiftTypeParameters,swiftTypeDeclaration
    \ /\<[A-Za-z_][A-Za-z_0-9\.]*\>[!?]\?/
" (Type[, Type]) (tuple)
" FIXME: we should be able to use skip="," and drop swiftParamDelim
syn region swiftType contained contains=swiftType,swiftParamDelim
    \ matchgroup=Delimiter start="[^@](" end=")" matchgroup=NONE skip=","
syn match swiftParamDelim contained
    \ /,/
" <Generic Clause> (generics)
syn region swiftTypeParameters contained contains=swiftVarName,swiftConstraint
    \ matchgroup=Delimiter start="<" end=">" matchgroup=NONE skip=","
syn keyword swiftConstraint contained
    \ where

syn match swiftTypeDeclaration skipwhite nextgroup=swiftType,swiftInOutKeyword
    \ /:/
syn match swiftTypeDeclaration skipwhite nextgroup=swiftType
    \ /->/

syn region swiftString oneline contains=swiftInterpolationRegion
    \ start=/"/ skip=/\\\\\|\\"/ end=/"/
syn region swiftInterpolationRegion oneline matchgroup=swiftInterpolation contained contains=TOP
    \ start=/\\(/ end=/)/
syn region swiftMultilineString contains=swiftInterpolationRegion
    \ start=/"""/ skip=/\\"\|\\\\/ end=/"""/
hi link swiftMultilineString swiftString

" comments: four types. (block, line) x (normal, doc)
syn region swiftBlockComment start="/\*" end="\*/" contains=swiftTodo
syn region swiftLineComment start="//" end="$" contains=swiftTodo

syn region swiftBlockDocComment start="/\*\*" end="\*/"
    \ contains=swiftTodo,swiftDocCommentKeyword,swiftDocCommentParameterName,swiftDocCommentFormatting
syn region swiftLineDocComment start="///" end="$"
    \ contains=swiftTodo,swiftDocCommentKeyword,swiftDocCommentParameterName,swiftDocCommentFormatting

" \ before [-+*] escapes that character, so don't highlight
syn match swiftDocCommentKeyword contained "\\\@<![\*+\-] \(
    \Attention\|
    \Authors\?\|
    \Bug\|
    \Complexity\|
    \Copyright\|
    \Callout([^)]*)\|
    \Date\|
    \Example\|
    \Experiment\|
    \Important\|
    \Invariant\|
    \Note\|
    \Postcondition\|
    \Precondition\|
    \Remark\|
    \Returns\|
    \Requires\|
    \SeeAlso\|
    \Since\|
    \Throws\|
    \ToDo\|
    \Version\|
    \Warning\|
    \\):"hs=s+2

syn region swiftDocCommentParameterName contained oneline matchgroup=swiftDocCommentKeyword
    \ start="[\*+\-] Parameter " skip="\\:" end=":"

" need at least 3 [*-_] on a separate line. whitespace is OK
" don't match if there's anything except / before. rough workaround, should be fine.
syn match swiftDocCommentFormatting contained "\([^/] *\)\@<!\( *-\)\{3,} *$"
syn match swiftDocCommentFormatting contained "\([^/] *\)\@<!\( *_\)\{3,} *$"
syn match swiftDocCommentFormatting contained "\([^/] *\)\@<!\( *\*\)\{3,} *$"

syn match swiftDecimal /[+\-]\?\<\([0-9][0-9_]*\)\([.][0-9_]*\)\?\([eE][+\-]\?[0-9][0-9_]*\)\?\>/
syn match swiftHex /[+\-]\?\<0x[0-9A-Fa-f][0-9A-Fa-f_]*\(\([.][0-9A-Fa-f_]*\)\?[pP][+\-]\?[0-9][0-9_]*\)\?\>/
syn match swiftOct /[+\-]\?\<0o[0-7][0-7_]*\>/
syn match swiftBin /[+\-]\?\<0b[01][01_]*\>/

syn match swiftOperator +\.\@<!\.\.\.\@!\|[/=\-+*%<>!&|^~]\@<!\(/[/*]\@![/=\-+*%<>!&|^~]*\|*/\@![/=\-+*%<>!&|^~]*\|->\@![/=\-+*%<>!&|^~]*\|[=+%<>!&|^~][/=\-+*%<>!&|^~]*\)+ skipwhite nextgroup=swiftTypeParameters
syn match swiftOperator "\.\.[<\.]" skipwhite nextgroup=swiftTypeParameters

syn match swiftChar /'\([^'\\]\|\\\(["'tnr0\\]\|x[0-9a-fA-F]\{2}\|u[0-9a-fA-F]\{4}\|U[0-9a-fA-F]\{8}\)\)'/

syn match swiftPreproc "#available"
syn match swiftPreproc "#colorLiteral"
syn match swiftPreproc "#column"
syn match swiftPreproc "#else"
syn match swiftPreproc "#elseif"
syn match swiftPreproc "#endif"
syn match swiftPreproc "#file"
syn match swiftPreproc "#fileLiteral"
syn match swiftPreproc "#function"
syn match swiftPreproc "#if"
syn match swiftPreproc "#imageLiteral"
syn match swiftPreproc "#line"
syn match swiftPreproc "#selector"
syn match swiftPreproc "#sourceLocation"

" ------ unused preprocessor branch highlighting ------

" allow the #else / #elseif to be highlighted, but not #endif
" NOTE: the #endif ones have to come first, otherwise they'll match first and the
" else/elseif highlighting will be clobbered
syn region swiftPreprocFalse
    \ start="#\(if\|elseif\)\s\+\<false\>"
    \ end="#endif\>"
    \ end="#\(else\>\|elseif\>\)\>"me=s-1

" highlight the alternate branch of an `#if true`
" TODO: not working yet; very tricky. maybe not possible at all in corner cases (chained trues)
" syn region swiftPreprocFalse
"     \ start="#\(if\|elseif\)\s\+\<true\>\_.\{-}#\(else\|elseif\|endif\)"ms=e
"     \ end="#endif\>"me=s-1
"     \ end="#\(else\>\|elseif\>\)\>"me=s-1

if !exists("g:schwifty_comment_unused_os_preproc")
    let g:schwifty_comment_unused_os_preproc=1
endif

if g:schwifty_comment_unused_os_preproc
    " comment chunks based on os() directives
    if has('macunix')
        syn region swiftPreprocFalse
            \ start="#\(elseif\|if\)\s\+os(Linux)"
            \ end="#endif\>"
            \ end="#\(else\>\|elseif\>\)"me=s-1
    else
        syn region swiftPreprocFalse
            \ start="#\(elseif\|if\)\s\+os(\(OSX\|macOS\|iOS\|watchOS\|tvOS\))"
            \ end="#endif\>"
            \ end="#\(else\>\|elseif\>\)"me=s-1
    endif
endif

" ------ miscellaneous groups -----

syn match swiftAttribute /@\<\w\+\>/ skipwhite nextgroup=swiftType

" Xcode's interface summary features don't work with these tags unless they're followed by :
" But we only want to highlight the word, so me=e-1
syn match swiftTodo /\(MARK\|TODO\|FIXME\):/me=e-1 contained

syn match swiftCastOp "\<is\>" skipwhite nextgroup=swiftType
syn match swiftCastOp "\<as\>[!?]\?" skipwhite nextgroup=swiftType

syn match swiftNilOps "??"

syn region swiftReservedIdentifier oneline
    \ start=/`/ end=/`/

hi def link swiftConstraint swiftKeyword

hi def link swiftImport Include
hi def link swiftImportModule Title
hi def link swiftImportComponent Identifier
hi def link swiftKeyword Statement
hi def link swiftMultiwordKeyword Statement
hi def link swiftTypeDefinition Define
hi def link swiftMultiwordTypeDefinition Define
hi def link swiftType Type
hi def link swiftTypePair Type
hi def link swiftTypeName Function
hi def link swiftFuncDefinition Define
hi def link swiftDefinitionModifier Define
hi def link swiftInOutKeyword Define
hi def link swiftFuncKeyword Function
hi def link swiftFuncKeywordGeneral Function
hi def link swiftVarDefinition Define
hi def link swiftVarName Identifier
hi def link swiftImplicitVarName Identifier
hi def link swiftIdentifierKeyword Identifier
hi def link swiftTypeDeclaration Delimiter
hi def link swiftTypeParameters Delimiter
hi def link swiftBoolean Boolean
hi def link swiftString String
hi def link swiftInterpolation Delimiter

hi def link swiftDecimal Number
hi def link swiftHex Number
hi def link swiftOct Number
hi def link swiftBin Number

hi def link swiftOperator Function
hi def link swiftChar Character
hi def link swiftLabel Operator
hi def link swiftMutating Statement
hi def link swiftPreproc PreCondit
hi def link swiftPreprocFalse Comment
hi def link swiftAttribute Type
hi def link swiftTodo Todo
hi def link swiftNil Constant
hi def link swiftCastOp Operator
hi def link swiftNilOps Operator
hi def link swiftScope PreProc

" link comment types together, to swiftComment
hi def link swiftLineComment swiftComment
hi def link swiftBlockComment swiftComment
hi def link swiftComment Comment

" link doc comment types together, to SpecialComment
hi def link swiftLineDocComment swiftDocComment
hi def link swiftBlockDocComment swiftDocComment
hi def link swiftDocComment SpecialComment

hi def link swiftDocCommentKeyword Special
hi def link swiftDocCommentParameterName swiftVarName
hi def link swiftDocCommentFormatting swiftDocCommentKeyword

let b:current_syntax = "swift"
