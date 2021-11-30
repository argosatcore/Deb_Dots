# Book Making

The following are some tips on a topic whose information is scarce in the world of Linux: the making of books. They involve the use of tools such as bash in conjunction with other very powerful command line utilities. Most of these utilities can be obtained by installing the Texlive suite, which is probably alvailable in your distribution's repositories. For Debian and Debian-based distributions you can install the full Texlive constellation of programs with the following command:

		sudo apt install texlive-full

## Imposition:

This is one of the most (if not the most) handliest feature for arranging book pages on a sheet of paper. There are a handful of programs that will let you do that, like `pdfbook2`, `pdfxup` and `impose+`, but the problem with them relies on their rigid predefined paper sizes. Luckily, `pdfjam` offers a very versatile way of handling booklet imposition and custom paper sizes, among other useful things.

		pdfjam --suffix book --papersize '{lengthcm, heightcm}' clip 'true' --trim  'leftcm,topcm,rightcm,bottomcm' --signature 'n' -- yourfile.pdf

