\version "2.18.2"
\include "articulate.ly"
#(set-global-staff-size 16)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  http://lsr.di.unimi.it/LSR/Item?id=445

%LSR by Jay Anderson.
%modyfied by Simon Albrecht on March 2014.
%=> http://lilypond.1069038.n5.nabble.com/LSR-445-error-td160662.html

#(define (octave-up m t)
 (let* ((octave (1- t))
      (new-note (ly:music-deep-copy m))
      (new-pitch (ly:make-pitch
        octave
        (ly:pitch-notename (ly:music-property m 'pitch))
        (ly:pitch-alteration (ly:music-property m 'pitch)))))
  (set! (ly:music-property new-note 'pitch) new-pitch)
  new-note))

#(define (octavize-chord elements t)
 (cond ((null? elements) elements)
     ((eq? (ly:music-property (car elements) 'name) 'NoteEvent)
       (cons (car elements)
             (cons (octave-up (car elements) t)
                   (octavize-chord (cdr elements) t))))
     (else (cons (car elements) (octavize-chord (cdr elements ) t)))))

#(define (octavize music t)
 (if (eq? (ly:music-property music 'name) 'EventChord)
       (ly:music-set-property! music 'elements (octavize-chord
(ly:music-property music 'elements) t)))
 music)

makeOctaves = #(define-music-function (parser location arg mus) (integer? ly:music?)
 (music-map (lambda (x) (octavize x arg)) (event-chord-wrap! mus)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cr = \change Staff = "right"
cl = \change Staff = "left"
rhMark = \markup { 
  \path #0.1 #'((moveto -1 0)(rlineto 0 -1.5)(rlineto 0.5 0))
}

\header {
  title = "田馥甄 - 小幸運"
  subtitle = "For (easy?) harp"
  arranger = "Arranged by Benson"
  composer = "Composed by JerryC"
  copyright = "https://music.bensonby.me"
  tagline = "https://music.bensonby.me"
}

upper-prelude = \relative c {
  \clef bass
  f8\( c' a' f, c'2\)
  g8\( b f' g, b2\)
  c,8\( e bes' c, e2\)
  f8\( g16 a c8 f, a2\)
}

bass-prelude = \relative c {
  R1*4
}

upper-episode = \relative c'' {
  <c c'>2\( a8 c f a g4 a8-. d,~-- d4.\) e16\(-. f-.
  g8-. bes,-. g'-. g16 fis g a bes a bes c bes c d bes c d e d e f g f e d c4\)
}

bass-episode = \relative c, {
  \makeOctaves 1 {
    f4 f f f g g g g c c c c c c c c
  }
}

melody-verse-one = \relative c' {
  \clef treble
  r8 a\( a c c f f e e d a d~ d4\) r
  r8 d\( d e e a a e e c a8 c~ c4\) r
  r8 a\( a c c f f e e d a d\) r4
  d8\( e8~ e dis e a~ a g4 f8~ f4\) r r2
}

bass-verse-one = \relative c {
  f1 g c, f2. e4 d1 g c, f2. <c bes'>4
}

melody-verse-two = \relative c' {
  \clef treble
  r8 a\( a c c f f e e d a d~ d4\) r
  r8 d\( d e e a a e e4 a,8 c~ c4\) r
  r8 a\( a c c f f e e f a, d\) r
  d8\( f e~ e dis e a~ a g4 f8~ f4\) r
}

bass-verse-two = \relative c {
  <f a>1 g c, f2. e4 d1 g c, f2. e4
}

melody-bridge-one = \relative c'' {
  a8\( g16 f~ f8 e d d d d d a'4 g8~ g4\) r
  g8\( e16 e~ e8 d c c c( a) c g'4 f8~ f4\) r8
  f8\( f c c f, a4 g8 d'~ d4\) r8 d\(~
  d8 d d d16 f~ f8 d f d f f f f a g4 g8~ g4\) r8
}

bass-bridge-one = \relative c {
  bes1 c2. bes4 a1 d
  g,1 b c c2 r2
}

melody-chorus-one = \relative c' {
  c8\( a'8 g16 f~ f8 g a c, g' a~ a c, g' a\)
  r8 g\( g a16 bes~ bes8 a g e f a, d f~ f a, d e\)
  r8 e\( e a16 c~ c8 a f e d bes'16 bes~ bes4\)
  r8 c\( bes a c, a'16 a~ a4\)
  r8 bes\( a f b, g'16 g~ g4\)
  r8 g\( f a~ a g( f) a~ a g4 f8\)

  a8\( c, g' a~ a c, g' a\)
  r8 g\( g a16 bes~ bes8 c g f f a, d f~ f a, d e\)
  r8 e\( e a16 c~ c8 a f e d bes'16 bes~ bes4\)
  r8 c\( bes a c, a'16 a~ a4\)
  r8 bes\( a f b, g'16 g~ g4\) r2
  r8 a\( f f a8. g16~ g8 f\)
}

bass-chorus-one = \relative c {
  f1 c d a bes f g c2 d4 e
  f1 c d a bes f g c
}

melody = \relative c' {
  \set fingeringOrientations = #'(up)
  \clef treble
  \tempo 4 = 79
  \time 4/4
  \key f \major
  R1*4
  \melody-verse-one
  \melody-verse-two
  \melody-bridge-one
  \melody-chorus-one
  R1*4
  % \bar "|."
}
upper = \relative c' {
  \set fingeringOrientations = #'(up)
  \clef treble
  \tempo 4 = 79
  \time 4/4
  \key f \major
  \upper-prelude
  \transpose c c' {
    \melody-verse-one
    \melody-verse-two
    \melody-bridge-one
    \melody-chorus-one
  }
  \upper-episode
  % \bar "|."
}

lower = \relative c' {
  \set fingeringOrientations = #'(down)
  \clef bass
  \time 4/4
  \key f \major
  \bass-prelude
  \bass-verse-one
  \bass-verse-two
  \bass-bridge-one
  \bass-chorus-one
  \bass-episode
  % \bar "|."
}

dynamics = {
  s1\mp s1*3
  s1*8
  s1\mf s1*31

  % episode
  s1\f s1*3

  s1\mf s1*31
}

lyrics-main = \lyricmode {
  我 聽 見 雨 滴 落 在 青 青 草 地
  我 聽 見 遠 方 下 課 鐘 聲 響 起
  可 是 我 沒 有 聽 見 你 的 聲 音
  認 真 呼 喚 我 姓 名

  愛 上 你 的 時 候 還 不 懂 感 情
  離 別 了 才 覺 得 刻 骨 銘 心
  為 什 麼 沒 有 發 現 遇 見 了 你 是 生 命 最 好 的 事 情

  也 許 當 時 忙 著 微 笑 和 哭 泣
  忙 著 追 逐 天 空 中 的 流 星
  人 理 所 當 然 的 忘 記
  是 誰 風 裡 雨 裡 一 直 默 默 守 護 在 原 地

  原 來 你 是 我 最 想 留 住 的 幸 運
  原 來 我 們 和 愛 情 曾 經 靠 得 那 麼 近
  那 為 我 對 抗 世 界 的 決 定 那 陪 我 淋 的 雨
  一 幕 幕 都 是 你 一 塵 不 染 的 真 心

  與 你 相 遇 好 幸 運
  可 我 已 失 去 為 你 淚 流 滿 面 的 權 利
  但 願 在 我 看 不 到 的 天 際 你 張 開 了 雙 翼
  遇 見 你 的 註 定 她 會 有 多 幸 運

  青 春 是 段 跌 跌 撞 撞 的 旅 行
  擁 有 著 後 知 後 覺 的 美 麗
  來 不 及 感 謝 是 你 給 我 勇 氣 讓 我 能 做 回 我 自 己

  也 許 當 時 忙 著 微 笑 和 哭 泣
  忙 著 追 逐 天 空 中 的 流 星
  人 理 所 當 然 的 忘 記
  是 誰 風 裡 雨 裡 一 直 默 默 守 護 在 原 地

  原 來 你 是 我 最 想 留 住 的 幸 運
  原 來 我 們 和 愛 情 曾 經 靠 得 那 麼 近
  那 為 我 對 抗 世 界 的 決 定 那 陪 我 淋 的 雨
  一 幕 幕 都 是 你 一 塵 不 染 的 真 心

  與 你 相 遇 好 幸 運
  可 我 已 失 去 為 你 淚 流 滿 面 的 權 利
  但 願 在 我 看 不 到 的 天 際
  你 張 開 了 雙 翼
  遇 見 你 的 註 定 Woooo
  她 會 有 多 幸 運
}

\score {
  <<
    \new Staff = "melodystaff" \with {
      fontSize = #-2
      \override StaffSymbol.staff-space = #(magstep -3)
      \override StaffSymbol.thickness = #(magstep -3)
    } <<
      \set Staff.midiInstrument = #"electric guitar (clean)"
      \set Staff.instrumentName = #"Vocal"
      \set Staff.midiMinimumVolume = #0.7
      \set Staff.midiMaximumVolume = #0.8
      \new Voice = "melody" {
        \melody
      }
      \context Lyrics = "lyrics" { \lyricsto "melody" { \lyrics-main } }
    >>
    \new PianoStaff <<
      \set PianoStaff.instrumentName = #"Piano"
      \new Staff = "right" {
        \set Staff.midiInstrument = #"acoustic grand"
        \set Staff.midiMinimumVolume = #0.9
        \set Staff.midiMaximumVolume = #1
        \upper
      }
      \new Dynamics = "Dynamics_pf" \dynamics
      \new Staff = "left" {
        \set Staff.midiInstrument = #"acoustic grand"
        \set Staff.midiMinimumVolume = #0.9
        \set Staff.midiMaximumVolume = #1
        \lower
      }
    >>
  >>
  \layout {
    \context {
      % add the RemoveEmptyStaffContext that erases rest-only staves
      \Staff \RemoveEmptyStaves
    }
    \context {
      % add the RemoveEmptyStaffContext that erases rest-only staves
      % \Dynamics \RemoveEmptyStaves
    }
    \context {
      \Score
      % Remove all-rest staves also in the first system
      \override VerticalAxisGroup.remove-first = ##t
      % If only one non-empty staff in a system exists, still print the starting bar
      \override SystemStartBar.collapse-height = #1
    }
    \context {
      \ChordNames
      \override ChordName #'font-size = #-3
    }
  }
  \midi {
    \context {
      \ChordNameVoice \remove Note_performer
    }
  }
}
