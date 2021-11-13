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

syn include @httpXml syntax/xml.vim
syn include @httpShell syntax/sh.vim
syn include @httpJson syntax/json.vim
" syn include @httpGraphql syntax/graphql.vim

syn case match

" (( Request Line ))

syn match httpRequestKeyword '\c^\(get\|post\|put\|delete\|patch\|head\|options\|connect\|trace\)' nextgroup=httpRequestConst contained
syn match httpRequestConst '.\{-1,}\s' nextgroup=httpProtocolVersion contained
syn match httpRequestLine '\c^\%(\(get\|post\|put\|delete\|patch\|head\|options\|connect\|trace\)\s\+\)\?\s*\(.\{-1,}\)\%(\s\+\(HTTP/\S\+\)\)\?$' contains=httpRequestKeyword

" (( Response Line ))

syn match httpResponseConst '[1-5][0-9][0-9]' nextgroup=httpResponseString contained
syn match httpResponseString '.*' contained
syn match httpResponseLine '\c^\s*\(HTTP/\S\+\)\s\([1-5][0-9][0-9]\)\s\(.*\)$' contains=httpProtocolVersion,httpResponseConst

" (( Protocol ))

syn match httpProtocol 'HTTP' contained
syn match httpVersion '\d\+.\d\+' contained
syn match httpProtocolVersion '\(HTTP\)/\(\d\+.\d\+\)' contained contains=httpProtocol,httpVersion

" (( Request Body ))

syn region httpRequestBodyCurl start='^\s*\(curl\)\@=' end='^\s*\(#\{3,}.\{-}\)\?\s*$' contains=@httpShell
syn region httpRequestBodyJson start='\s*\(\[\|{[^{]\|{\_s\)\@=' end='^\s*\(#\{3,}.\{-}\)\?\s*$' contains=@httpJson
syn region httpRequestBodyXml start='^\s*\(<\S\)\@=' end='^\s*\(#\{3,}.\{-}\)\?\s*$' contains=@httpXml
syn region httpRequestBodyGraphql start='\s*\(query\|mutation\)\@=' end='^\s*\(#\{3,}.\{-}\)\?\s*$' contains=@httpGraphql
" syn region httpRequestBodyGraphql start='\s*\(query\|mutation\)\@=' end='^{\s*$' contains=@httpGraphql


" (( File variable ))

syn match httpFileKeyword '@' nextgroup=httpFileVariable contained
syn match httpFileVariable '\([^[:blank:]=]\+\)' nextgroup=httpFileEqual contained
syn match httpFileEqual '\s*=\s*' nextgroup=httpFileString contained
syn match httpFileString '\(.\{-}\)\s*$' contained
syn match httpFile '^\s*\(@\)\([^[:blank:]=]\+\)\s*=\s*\(.\{-}\)\s*$' contains=httpFileKeyword

" (( Query ))

syn match httpQueryKeyword '\(?\|&\)' nextgroup=httpQueryVariable contained
syn match httpQueryVariable '\([^[:blank:]=]\+\)' nextgroup=httpQueryEqual contained
syn match httpQueryEqual '=' nextgroup=httpQueryString contained
syn match httpQueryString '.*$' contained
syn match httpQuery '^\s*\(?\|&\)\([^[:blank:]=]\+\)=\(.*\)$' contains=httpQueryKeyword

" (( Header ))

syn match httpHeaderEntity '[[:alnum:]_-]\+' nextgroup=httpHeaderKeyword contained
syn match httpHeaderKeyword ':' nextgroup=httpHeaderString contained
syn match httpHeaderString '\([^/].\{-}\)\s*$' contained
syn match httpHeaders '^\([[:alnum:]_-]\+\)\s*\(:\)\s*\([^/].\{-}\)\s*$' contains=httpHeaderEntity

" (( Comment ))

syn match httpCommentLineName '\s@name\s[^[:blank:].]\+$' contains=httpCommentLineKeyword contained
syn match httpCommentLineNote '\s@note\s*$' contains=httpCommentLineKeyword contained
syn match httpCommentLineString '\s[^[:blank:].]\+$' contained
syn match httpCommentLineKeyword '@' contained

syn match httpCommentLineSharp '^\s*#\{1,}.*$' display contains=httpCommentLineName,httpCommentLineNote
syn match httpCommentLineDoubleSlash '^\s*/\{2,}.*$' display contains=httpCommentLineName,httpCommentLineNote


hi link httpFileKeyword Keyword
hi link httpFileVariable Identifier
hi link httpFileString String
hi link httpQueryKeyword Keyword
hi link httpQueryVariable Identifier
hi link httpQueryString String
hi link httpHeaderEntity Special
hi link httpHeaderKeyword Delimiter
hi link httpHeaderString String
hi link httpCommentLineSharp Comment
hi link httpCommentLineDoubleSlash Comment
hi link httpCommentLineKeyword Type
hi link httpCommentLineName Special
hi link httpCommentLineNote Special
hi link httpRequestKeyword Keyword
hi link httpRequestConst Constant
hi link httpResponseConst Constant
hi link httpResponseString String
hi link httpProtocol Keyword
hi link httpVersion Constant

let b:current_syntax = 'http'

let &cpo = s:cpo_save
unlet s:cpo_save
