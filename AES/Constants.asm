INCLUDE AES.inc			

.data
S_BOX		BYTE 063h, 07ch, 077h, 07bh, 0f2h, 06bh, 06fh, 0c5h, 030h, 001h, 067h, 02bh, 0feh, 0d7h, 0abh, 076h
			BYTE 0cah, 082h, 0c9h, 07dh, 0fah, 059h, 047h, 0f0h, 0adh, 0d4h, 0a2h, 0afh, 09ch, 0a4h, 072h, 0c0h
			BYTE 0b7h, 0fdh, 093h, 026h, 036h, 03fh, 0f7h, 0cch, 034h, 0a5h, 0e5h, 0f1h, 071h, 0d8h, 031h, 015h
			BYTE 004h, 0c7h, 023h, 0c3h, 018h, 096h, 005h, 09ah, 007h, 012h, 080h, 0e2h, 0ebh, 027h, 0b2h, 075h
			BYTE 009h, 083h, 02ch, 01ah, 01bh, 06eh, 05ah, 0a0h, 052h, 03bh, 0d6h, 0b3h, 029h, 0e3h, 02fh, 084h
			BYTE 053h, 0d1h, 000h, 0edh, 020h, 0fch, 0b1h, 05bh, 06ah, 0cbh, 0beh, 039h, 04ah, 04ch, 058h, 0cfh
			BYTE 0d0h, 0efh, 0aah, 0fbh, 043h, 04dh, 033h, 085h, 045h, 0f9h, 002h, 07fh, 050h, 03ch, 09fh, 0a8h
			BYTE 051h, 0a3h, 040h, 08fh, 092h, 09dh, 038h, 0f5h, 0bch, 0b6h, 0dah, 021h, 010h, 0ffh, 0f3h, 0d2h
			BYTE 0cdh, 00ch, 013h, 0ech, 05fh, 097h, 044h, 017h, 0c4h, 0a7h, 07eh, 03dh, 064h, 05dh, 019h, 073h
			BYTE 060h, 081h, 04fh, 0dch, 022h, 02ah, 090h, 088h, 046h, 0eeh, 0b8h, 014h, 0deh, 05eh, 00bh, 0dbh
			BYTE 0e0h, 032h, 03ah, 00ah, 049h, 006h, 024h, 05ch, 0c2h, 0d3h, 0ach, 062h, 091h, 095h, 0e4h, 079h
			BYTE 0e7h, 0c8h, 037h, 06dh, 08dh, 0d5h, 04eh, 0a9h, 06ch, 056h, 0f4h, 0eah, 065h, 07ah, 0aeh, 008h
			BYTE 0bah, 078h, 025h, 02eh, 01ch, 0a6h, 0b4h, 0c6h, 0e8h, 0ddh, 074h, 01fh, 04bh, 0bdh, 08bh, 08ah
			BYTE 070h, 03eh, 0b5h, 066h, 048h, 003h, 0f6h, 00eh, 061h, 035h, 057h, 0b9h, 086h, 0c1h, 01dh, 09eh
			BYTE 0e1h, 0f8h, 098h, 011h, 069h, 0d9h, 08eh, 094h, 09bh, 01eh, 087h, 0e9h, 0ceh, 055h, 028h, 0dfh
			BYTE 08ch, 0a1h, 089h, 00dh, 0bfh, 0e6h, 042h, 068h, 041h, 099h, 02dh, 00fh, 0b0h, 054h, 0bbh, 016h


INV_S_BOX	BYTE 052h, 009h, 06ah, 0d5h, 030h, 036h, 0a5h, 038h, 0bfh, 040h, 0a3h, 09eh, 081h, 0f3h, 0d7h, 0fbh
			BYTE 07ch, 0e3h, 039h, 082h, 09bh, 02fh, 0ffh, 087h, 034h, 08eh, 043h, 044h, 0c4h, 0deh, 0e9h, 0cbh
			BYTE 054h, 07bh, 094h, 032h, 0a6h, 0c2h, 023h, 03dh, 0eeh, 04ch, 095h, 00bh, 042h, 0fah, 0c3h, 04eh
			BYTE 008h, 02eh, 0a1h, 066h, 028h, 0d9h, 024h, 0b2h, 076h, 05bh, 0a2h, 049h, 06dh, 08bh, 0d1h, 025h
			BYTE 072h, 0f8h, 0f6h, 064h, 086h, 068h, 098h, 016h, 0d4h, 0a4h, 05ch, 0cch, 05dh, 065h, 0b6h, 092h
			BYTE 06ch, 070h, 048h, 050h, 0fdh, 0edh, 0b9h, 0dah, 05eh, 015h, 046h, 057h, 0a7h, 08dh, 09dh, 084h
			BYTE 090h, 0d8h, 0abh, 000h, 08ch, 0bch, 0d3h, 00ah, 0f7h, 0e4h, 058h, 005h, 0b8h, 0b3h, 045h, 006h
			BYTE 0d0h, 02ch, 01eh, 08fh, 0cah, 03fh, 00fh, 002h, 0c1h, 0afh, 0bdh, 003h, 001h, 013h, 08ah, 06bh
			BYTE 03ah, 091h, 011h, 041h, 04fh, 067h, 0dch, 0eah, 097h, 0f2h, 0cfh, 0ceh, 0f0h, 0b4h, 0e6h, 073h
			BYTE 096h, 0ach, 074h, 022h, 0e7h, 0adh, 035h, 085h, 0e2h, 0f9h, 037h, 0e8h, 01ch, 075h, 0dfh, 06eh
			BYTE 047h, 0f1h, 01ah, 071h, 01dh, 029h, 0c5h, 089h, 06fh, 0b7h, 062h, 00eh, 0aah, 018h, 0beh, 01bh
			BYTE 0fch, 056h, 03eh, 04bh, 0c6h, 0d2h, 079h, 020h, 09ah, 0dbh, 0c0h, 0feh, 078h, 0cdh, 05ah, 0f4h
			BYTE 01fh, 0ddh, 0a8h, 033h, 088h, 007h, 0c7h, 031h, 0b1h, 012h, 010h, 059h, 027h, 080h, 0ech, 05fh
			BYTE 060h, 051h, 07fh, 0a9h, 019h, 0b5h, 04ah, 00dh, 02dh, 0e5h, 07ah, 09fh, 093h, 0c9h, 09ch, 0efh
			BYTE 0a0h, 0e0h, 03bh, 04dh, 0aeh, 02ah, 0f5h, 0b0h, 0c8h, 0ebh, 0bbh, 03ch, 083h, 053h, 099h, 061h
			BYTE 017h, 02bh, 004h, 07eh, 0bah, 077h, 0d6h, 026h, 0e1h, 069h, 014h, 063h, 055h, 021h, 00ch, 07dh


ENC_MATRIX	BYTE 002, 003, 001, 001
			BYTE 001, 002, 003, 001
			BYTE 001, 001, 002, 003
			BYTE 003, 001, 001, 002


DEC_MATRIX	BYTE 0eh, 0bh, 0dh, 09h
			BYTE 09h, 0eh, 0bh, 0dh
			BYTE 0dh, 09h, 0eh, 0bh
			BYTE 0bh, 0dh, 09h, 0eh


ROUND_TABLE	BYTE 01h, 02h, 04h, 08h, 10h, 20h, 40h, 80h, 1bh, 36h
			BYTE 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
			BYTE 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
			BYTE 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

KEY_EXPAN	BYTE 176 Dup (?)

END