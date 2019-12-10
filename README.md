# Secured Communication

## Starting Projects

1. In **Solution Explorer**, select the **solution** _(the top node)_.
2. Choose the solution node's context _(right-click)_ menu and then choose **Properties**.
3. Expand the **Common Properties** node, and choose **Startup Project**.
4. Choose **Multiple Startup Projects**.
5. Move **Server** Project followed by the **Client** Project to the **top** and set their actions to `Start`.
6. Click **Apply**.
7. Press (`CTRL` + `F5`) to start projects without debugging.

---

## Guidelines

<!-- TOC depthFrom:3 depthTo:4 -->

- [1. Naming Conventions](#1-naming-conventions)
- [2. Formatting](#2-formatting)
    - [2.1. Alignment](#21-alignment)
    - [2.2. Statements Format](#22-statements-format)
- [3. Documenting Parametrized Procedures](#3-documenting-parametrized-procedures)
- [4. Commenting](#4-commenting)
    - [4.1. No Trivial Comments](#41-no-trivial-comments)
    - [4.2. Standalone Comments](#42-standalone-comments)

<!-- /TOC -->

### 1. Naming Conventions

| Identifier   | Case         | Example                                                                                                    |
| ------------ | ------------ | ---------------------------------------------------------------------------------------------------------- |
| Segments     | lowercase    | `.data`, `.code`                                                                                           |
| Instructions | lowercase    | `loop`, `pushad`                                                                                           |
| Registers    | lowercase    | `eax`, `ah`, `al`                                                                                          |
| Labels       | PascalCase\* | `ForLoop:`                                                                                                 |
| Constants    | PascalCase   | `CirclePI = 3.16`                                                                                          |
| Procedures   | PascalCase   | `MyProcedure`                                                                                              |
| Directives   | UPPERCASE    | `BYTE`, `WORD`, `DWORD`<br> `PROC`, `ENDP`, `INVOKE` <br> `LENGTHOF`, `SIZEOF`<br> `TYPE`, `OFFSET`, `PTR` |

> \* Always less than or equal 10 characters.

### 2. Formatting

#### 2.1. Alignment

Always align same **identifiers** on the same **column** for better readability.

```assembly
.data
total           WORD    0F10h
sum             DWORD   0
errorMessage    BYTE    "Invalid Choice!", 0
message         BYTE    "Hello World!", 0
```

#### 2.2. Statements Format

1. Indent your statements with **3 tabs**.
1. Put your labels on the **same line** of the instruction in the indentation whitespace.
1. Align your instruction at the stop of the **third** tab from **column one**.
1. Align your operands at the stop of the **second** tab from the **instructions** column.
1. Separate your operands with a **comma** followed by a **whitespace**.
1. Align your comments all on the **same column** though out the whole source code.

```assembly
Lbl:[··][··]mov·[··]ecx,·ebx[··][··];·comment for labeled instruction
[··][··][··]mov·[··]ecx,·ebx[··][··];·comment for 3-chars-long instruction
[··][··][··]xchg[··]ecx,·ebx[··][··];·comment for 4-chars-long instruction
[··][··][··]movzx[·]ecx,·ebx[··][··];·comment for 5-chars-long instruction


- ·    = 1 whitespace
- ··   = 2 whitespaces
- [·]  = 3 whitespaces
- [··] = 4 whitespaces (tab)
```

### 3. Documenting Parametrized Procedures

Use the following template for commenting your procedures.

```assembly
;-----------------------------------------------------
PromptForIntegers PROC,
    ptrPrompt   :PTR BYTE,  ; prompt string
    ptrArray    :PTR DWORD, ; pointer to array
    arraySize   :DWORD      ; size of the array
;
; Prompts the user for an array of integers and fills
; the array with the user's input.
; Returns: nothing
;-----------------------------------------------------
```

### 4. Commenting

#### 4.1. No Trivial Comments

1. Don’t explain the actions of an instruction in your code **unless** that instruction is doing something that isn’t obvious.
1. Write your comments in such a way that **minor changes** to the instruction **do not require** that you **change** the corresponding comment.

```assembly
Bad:        mov     ax, 0       ; Set AX to zero. (Worse than no comment at all)
Good:       mov     ax, 0       ; AX is the resulting sum. Initialize it.*
```

> \* Note that the comment does not say "Initialize it to zero." Although there would be nothing intrinsically wrong with saying this, the phrase "Initialize it" remains true no matter what value you assign to `ax`.

#### 4.2. Standalone Comments

1. Whenever a comment appears on a line by **itself**, always put the semicolon in **column one**. You may indent the text if this is appropriate or aesthetic.

   ```assembly
   ; Compute the transpose of a matrix using the algorithm:
   ;
   ; for i := 0 to 3 do
   ;   for j := 0 to 3 do
   ;       swap( a[i][j], b[j][i] );

               mov      ecx, 3
    forlp1:    mov      ebx, ecx
               mov      ecx, 3
    forlp2:    ...
               loop     forlp2
               loop     forlp1
   ```

1. Adjacent lines of comments should not have any interspersed blank lines. A **blank** comment line should, at least, **contain a semicolon** in column one.

   ```assembly
   ; This is a comment with a blank line between it and the next comment.
   ;
   ; This is another line with a comment on it.
   ```
