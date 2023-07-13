\LoadClassWithOptions{article}

\RequirePackage{polyglossia}
\setdefaultlanguage{french}

\RequirePackage{fontspec}
\setmonofont{Inconsolata}

\RequirePackage{shellesc}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{amsmath,amssymb}
\RequirePackage{graphicx}
\RequirePackage{pifont,euscript}
\RequirePackage{rotating}
\RequirePackage[a4paper]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{tikz}
\RequirePackage{multicol}
\RequirePackage{upquote}
\RequirePackage{textcomp}
\RequirePackage{minted}
\RequirePackage{mdframed}
\RequirePackage{csquotes}
\RequirePackage[pdfencoding=auto]{hyperref}

\newcommand{\course}[1]{\def \thecoursename {#1}}
\newcommand{\curriculum}[1]{\def \thecurriculum {#1}}
\newcommand{\myyear}[1]{\def \theyear {#1}}
\newcommand{\mytitle}[1]{\title{\color{BrickRed}#1}}
\author{}
\date{}

\fancyhead[L]{\includegraphics[height=1.1cm]{UPEM-IGM-V1_300dpi.png}}
\fancyhead[C]{{\bf \thecoursename}\\
\thecurriculum\\
\theyear}
\fancyhead[R]{\includegraphics[height=1.3cm]{logo-ligm.png}}
\setlength{\headheight}{50pt}
\renewcommand{\headrulewidth}{1pt}

\setminted{linenos=false, mathescape, fontfamily=tt}
\newminted[python]{python3}{}
\newminted[pycon]{pycon}{python3}
\newminted[shell]{shell-session}{}
\newmintinline[pyinline]{python3}{}
\newmintedfile[pyfile]{python3}{}
\newcommand{\code}{\pyinline}

% cadres informatifs
\newcommand{\but}[1]{
\begin{mdframed}[innertopmargin=8pt,innerbottommargin=8pt]
\textbf{Objectif :} #1
\end{mdframed}
}

\newcommand{\rappel}[1]{
\begin{mdframed}[linecolor=BrickRed,innertopmargin=8pt,innerbottommargin=8pt]
#1
\end{mdframed}
}

\newcommand{\warning}[1]{
\begin{mdframed}[linecolor=BrickRed,innertopmargin=8pt,innerbottommargin=8pt]
\hangindent=1cm\hangafter=-2
{\color{BrickRed}\makebox[0pt][r]{\dbendleft\quad}\textbf{Attention :}}
#1
\end{mdframed}
}

% quelques symboles

\font\manual=manfnt % font used for the METAFONT logo, etc.
\def\barble{{\manual\char1}}
\def\fulltriangleright{{\manual\char120}} %
\def\fulltriangleup{{\manual\char54}} %
\def\fulltriangledown{{\manual\char55}}
\def\littlecube{{\manual\char28}}
\def\prettystar{{\manual\char30}}
\def\littlecircles{{\manual\char36}}
\def\littlelosanges{{\manual\char37}}
\def\littlecloud{{\manual\char38}}
\def\ellipsoid{{\manual\char88}}
\def\zip{{\manual\char121}} % -/\/->
\def\dbendright{{\manual\char126}}
\def\dbendleft{{\manual\char127}}
\def\question{\noindent\llap{\ding{90}\ding{212}}{\kern1pc}}

% Environnements d'exercices

% exercice simple
\newcounter{exo_count}
\def\exoname{Exercice}
\newenvironment{exercice}[1][]%
{\smallbreak\refstepcounter{exo_count}%
\vspace{0.3cm}%
\noindent{\fulltriangleright\kern 2pt%
\bf\exoname~\arabic{exo_count} : #1} \nopagebreak %
}%
{}

% exercice un peu plus difficile
\newenvironment{Exercice}[1][]%
{\bigbreak\refstepcounter{exo_count}%
\vspace{0.3cm}%
\begin{sloppypar}\noindent\hangindent -.9cm\ignorespaces%
{\bf \llap{\hbox to .9cm{\dbendleft}\fulltriangleright\kern 2pt}%
\exoname~\arabic{exo_count} : #1}%
}%
{\end{sloppypar}%
}

% exercice encore un peu plus difficile
\newenvironment{EXercice}%
{\bigbreak\refstepcounter{exo_count}%
\vspace{0.3cm}%
\begin{sloppypar}\noindent\hangindent 1.3cm\hangafter=-2\ignorespaces%
{\bf \llap{\hbox to 1.3cm{\dbendleft\kern1pt\dbendleft\hfill\hfill%
\fulltriangleright\kern 2pt}}%
\exoname~\arabic{exo_count}.}%
}%
{\end{sloppypar}%
}

% Corrections

\newif\ifCORRECTION
\CORRECTIONfalse

% environnement correction
\newbox\debutcor
\newbox\fincor
\def\setcorboxes#1{
  \setbox\debutcor=\hbox to #1{%
      \Large\ding{33}\small\leaders\hbox to .6em{\hfill\rule{2pt}{.8pt}}\hss}%
  \setbox\fincor=\hbox{\begin{turn}{180}\copy\debutcor\end{turn}}%
  }

\def\corrname{correction}
\def\correction{%
  \ifCORRECTION
  \par\bigbreak
  \typeout{Warning: correction ex.\arabic{exo_count} included}
  \setcorboxes{\linewidth}
  \noindent\ \kern-1ex\copy\debutcor\par\nobreak
  \bgroup\normalfont\small\noindent\ignorespaces%
  \else
  \typeout{Correction ex.\arabic{exo_count} ignored}
  \setbox0=\vbox\bgroup\small\noindent\ignorespaces%
  \fi
}
\def\endcorrection{%
  \egroup\par
  \ifCORRECTION
  \vspace*{-.5em}
  \nobreak\noindent\copy\fincor%\bigbreak
  \par\ignorespaces\noindent%
  \fi
}

% correction a inserer au milieu du texte
\def\corr#1{\ifCORRECTION{\color{BrickRed}{\bf Élément de correction :} #1}\fi}
