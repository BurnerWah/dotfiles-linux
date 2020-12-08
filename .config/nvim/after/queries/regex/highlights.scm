; This makes regex more readable

; Unfortunately, this parser mostly targets JS regex above all elese.
; Unsupported tokens:
; - \Q...\E - Literals (PCRE)
; - \k<$group_name> - Match named subpattern
; - \k'$group_name' - Match named subpattern (PCRE)
; - \k{$group_name} - Match named subpattern (PCRE)
; - \g... - Several unsupported tokens (PCRE)
; - *+ - Posessive quantifier (PCRE)
; - Most PCRE Group Contructus
; - [:...:] - Special character classes (PCRE)

; Explicit quantifiers
(count_quantifier (decimal_digits) @number)
(count_quantifier "," @punctuation.delimiter)

; Quantifiers
[
 (optional) ; the "?" token - could be set to @boolean
 (lazy) ; To cover lazy quantifiers
] @operator

; Any character
(any_character) @punctuation.special

; Character class negation
(character_class "^" @operator)

; Character class ranges
(class_range "-" @punctuation.delimiter)

; Unicode properties - this might be bad
(unicode_property_value_expression) @property
