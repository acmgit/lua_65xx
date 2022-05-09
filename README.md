# lua_65xx
Small Assembler for 65xx and 80xx written in Lua.

Features are that the Assembler has modules. So you can easy develop your own commands.
It automatically produces a prg-File for the Commodore 64.
It supports the illegal Opcodes of the Commodore 64

## Platforms:
All where Lua is running.

## License
GPL 3.0 on Deadsoft Development Software

## Install
You only need a Lua-Interpreter to run this Assembler.

## Download
https://github.com/acmgit/lua_65xx.git 

## Release
V 1.0

## Author
a.c.m. <undertakers_help@yahoo.com>

## Changes

V 1.0
    First Release
    
## Short Description

The assembler supports labels. To define a label, you can write:

MyLabel:
    lda #20
    sta $d020
    rts

Take care, a label has to be in a line alone. Or you can define Labels,
like this:

    Print: = $ab1e
    Basicstart: = $0801
    
If you want to use now the labels in your code, the label must be between
2 Brackets:

    lda #[red:]
    sta $d021
    
Every Programm needs a start, for this is you can use the Star:

* = $c000

This sets the Base to $c000, so you can later start it with sys 49152.
But a programm has not only commands, you need data for sprites, tabels and so on.
To define such space, use:

    dc 01, $ab, %1000011, [red:]
    
For text use only
    dc [This is a Text], $00

Another Feature is, you can use Formulas in your Source-Code. This Formula must be
between 2 {} brackets.

    lda #{$01 + 25 - %1001 / $a}
    
This is a valid Formula and will be calculated and inserted in your Code.
The differen Bases for Digits are

    $     Hexdecimal
    %     Binary
    
and the other digits are automatically decimal.

