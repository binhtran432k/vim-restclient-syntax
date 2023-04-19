if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'http'
endif

let s:cpo_save = &cpo
set cpo&vim

if exists('g:render_http_result')
  syn include @httpXml syntax/html.vim
  syn include @httpJson syntax/json.vim
else
  syn include @httpXml syntax/xml.vim
  syn include @httpJson syntax/json.vim
  syn include @httpJavascript syntax/javascript.vim
  syn include @httpShell syntax/sh.vim
  " syn include @httpGraphql syntax/graphql.vim
endif

syn case match

" (( Request Line ))

syn match httpRequestKeyword '\c^\(get\|post\|put\|delete\|patch\|head\|options\|connect\|trace\)' nextgroup=httpRequestQuery contained
syn match httpRequestQuery '.\{-1,}$' contains=httpUrl contained
syn match httpRequestLanguage '.\{-1,}$' contains=httpEndProtocolVersion,httpScript contained
syn match httpUrl '\(\s*\)\@<=\S\+\(\s\|$\)\@=' contains=httpScript nextgroup=httpEndProtocolVersion contained
syn match httpEndProtocolVersion '\s\+HTTP/\S\+$' contains=httpProtocolVersion contained
syn match httpRequestLine '\c^\(.\{-1,}\)\%(\s\+\(HTTP/\S\+\)\)\?$' contains=httpRequestLanguage
syn match httpRequestLine '\c^\%(\(get\|post\|put\|delete\|patch\|head\|options\|connect\|trace\)\s\+\)\(.\{-1,}\)\%(\s\+\(HTTP/\S\+\)\)\?$' contains=httpRequestKeyword

" (( Response Line ))

syn match httpResponseNumber '[1-5][0-9][0-9]' nextgroup=httpResponseString contained
syn match httpResponseString '.*' contained
syn match httpResponseLine '\c^\s*\(HTTP/\S\+\)\s\([1-5][0-9][0-9]\)\s\(.*\)$' contains=httpProtocolVersion,httpResponseNumber

" (( Protocol ))

syn match httpProtocol 'HTTP' contained
syn match httpVersion '\d\+.\d\+' contained
syn match httpProtocolVersion '\(HTTP\)/\(\d\+.\d\+\)' contained contains=httpProtocol,httpVersion

" (( Request Body ))

if !exists('g:render_http_result')
  syn region httpScript matchgroup=httpKeyword start='{{' end='}}' contains=@httpJavascript contained
  syn region httpRequestBodyCurl matchgroup=httpCommentLineSharp start='^\_s*\(curl\)\@=' end='^\_s*\(#\{3,}.\{-}\)\?\s*$' contains=@httpShell
  " syn region httpRequestBodyGraphql start='^\_s*\(query\|mutation\)\@=' end='^{\s*$' contains=@httpGraphql
  " syn region httpRequestBodyGraphql matchgroup=httpCommentLineSharp start='^\_s*\(query\|mutation\)\@=' end='^\s*\(#\{3,}.\{-}\)\?\s*$' contains=@httpGraphql
else
endif
syn region httpRequestBodyJson matchgroup=httpCommentLineSharp start='^\_s*\(\[\|{[^{]\|{\_s\)\@=' end='^\_s*\(#\{3,}.\{-}\)\?\s*$' contains=@httpJson
syn region httpRequestBodyXml matchgroup=httpCommentLineSharp start='^\_s*\(<\S\)\@=' end='^\_s*\(#\{3,}.\{-}\)\?\s*$' contains=@httpXml

" http string
syn match httpString '.*$' contains=httpScript contained

" (( File variable ))

syn match httpFileKeyword '@' nextgroup=httpFileVariable contained
syn match httpFileVariable '\([^[:blank:]=]\+\)' nextgroup=httpFileEqual contained
syn match httpFileEqual '\s*=\s*' nextgroup=httpString contained
syn match httpFile '^\s*\(@\)\([^[:blank:]=]\+\)\s*=\s*\(.\{-}\)\s*$' contains=httpFileKeyword

" (( Query ))

syn match httpQueryKeyword '\(?\|&\)' nextgroup=httpQueryVariable contained
syn match httpQueryVariable '[^[:blank:]=]\+' nextgroup=httpQueryEqual contained
syn match httpQueryEqual '=' nextgroup=httpString contained
syn match httpQuery '^\s*[^?&:blank:]\([^[:blank:]=]\+\)=\(.*\)$' contains=httpQueryVariable
syn match httpQuery '^\s*\(?\|&\)\([^[:blank:]=]\+\)=\(.*\)$' contains=httpQueryKeyword
syn match httpQuery '^\s*/.*$' contains=httpUrl

" (( Header ))

syn match httpHeaderEntity '[[:alnum:]_-]\+' nextgroup=httpHeaderKeyword contained
syn match httpHeaderKeyword ':' nextgroup=httpHeaderString contained
syn match httpHeaderString '\([^/].\{-}\)\s*$' contained
syn match httpHeaders '^\([[:alnum:]_-]\+\)\s*\(:\)\s*\([^/].\{-}\)\s*$' contains=httpHeaderEntity

" (( Comment ))

syn match httpCommentLineLabel '@\<\(name\|ref\|forceRef\)\s[^[:blank:].]\+$' contains=httpCommentLineKeyword,httpCommentLineString contained
syn match httpCommentLineLabel '@\<\(title\|description\|import\|disabled\|note\)\>.*$' contains=httpCommentLineKeyword,httpCommentLineString contained
syn match httpCommentLineString '\s.\{-1,}$' contained
syn match httpCommentLineKeyword '@' contained

syn match httpCommentLineSharp '^\s*#\{1,}.*$' display contains=httpCommentLineLabel
syn match httpCommentLineDoubleSlash '^\s*/\{2,}.*$' display contains=httpCommentLineLabel

hi link httpKeyword Keyword
hi link httpIdentifier Identifier
hi link httpString String
hi link httpSpecial Special
hi link httpComment Comment
hi link httpNormal Normal
hi link httpFunction Function
hi link httpType Type
hi link httpNumber Number

hi link httpFileKeyword httpKeyword
hi link httpFileVariable httpIdentifier
hi link httpFileString httpString
hi link httpQueryKeyword httpKeyword
hi link httpQueryVariable httpIdentifier
hi link httpQueryString httpString
hi link httpHeaderEntity httpSpecial
hi link httpHeaderKeyword httpKeyword
hi link httpHeaderString httpString
hi link httpCommentLineSharp httpComment
hi link httpCommentLineDoubleSlash httpComment
hi link httpCommentLineLabel httpFunction
hi link httpCommentLineKeyword httpFunction
hi link httpCommentLineString httpType
hi link httpRequestKeyword httpKeyword
hi link httpRequestLanguage httpNormal
hi link httpResponseNumber httpNumber
hi link httpResponseString httpString
hi link httpProtocol httpKeyword
hi link httpVersion httpNumber
hi link httpUrl Underlined

let b:current_syntax = 'http'

let &cpo = s:cpo_save
unlet s:cpo_save
