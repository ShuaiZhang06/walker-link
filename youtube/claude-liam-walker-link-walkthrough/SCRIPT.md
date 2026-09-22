# SCRIPT — Walker, Forked. · 中英对照

> **成片全程英文口播。** 下面每段的中文是给人读的对照译文：它不在片子里，没有配音，
> 也没有烧进画面，改它不会改变任何一帧。

> **`beat_sheet.json` 才是唯一真源。** Kokoro 逐字读 `beats[].narration_text`，所以
> 要改文案就改那个 JSON 再重跑 `generate_audio_kokoro.py`；改这个文件不会影响成片。

**claude-liam-walker-link-walkthrough** · 5:09.5 · 18 beats · 1050 spoken words · 配音 `am_onyx`（Liam，替 Bear 出镜）· kokoro · 无字幕

---

## 0:00.00 · B00 — cold open — the Walker ask
### 冷开场 —— Walker 的那句请求

`15.53s` · Remotion 卡片 `ClaudeComposerAsk`

**EN — spoken**

> Sawubona — this is Liam, in for Bear. That prompt is an illustrative
> reconstruction. It shows you the shape of the ask; it is not a transcript of
> anything anyone typed. What is real is the thing underneath it: a starter
> platformer, a fork of it, and a build I am about to play in front of you.

**中文 — 对照译文**

> Sawubona ——我是 Liam，替 Bear 出镜。屏幕上这段提示词是一次示意性的重构：
> 它让你看清这个请求大概长什么样，但它不是任何人真正敲下过的记录。真实的是它底下的东西——一个 starter 平台跳跃游戏、
> 一个它的 fork，以及我马上要当着你的面玩一遍的这个构建。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 问候 greeting | Sawubona, Liam | Sawubona（祖鲁语「你好」），Liam |
| 输入框 composer | Please use Walker to convert my game design document about a small Godot platformer — a green-capped adventurer crossing a short course of ledges, gaps and spikes, one fixed-height jump, unlimited retries — into a playable Godot project I can run, read and extend. | 请用 Walker 把我关于一个小型 Godot 平台跳跃游戏的设计文档，转成一个我能运行、能读、能扩展的可玩 Godot 项目——一个戴绿帽的冒险者穿过一小段由岩架、缺口和尖刺组成的路线，单段定高跳跃，无限重试。 |
| 运行行 running | reconstructed prompt — illustrative, not a transcript… | 重构的提示词 —— 示意用，非实录…… |
| 输出 output | Starter: nikbearbrown/walker-jumpman — “First Steps”, Godot 4.7.2. | Starter：nikbearbrown/walker-jumpman ——「First Steps」，Godot 4.7.2。 |
| 输出 output | Fork: ShuaiZhang06/walker-link @ 19a7ddd — new character, new Section 03. | Fork：ShuaiZhang06/walker-link @ 19a7ddd —— 新角色，新增 Section 03。 |
| 输出 output | Played below input-only; tuning.gd and the player collider untouched. | 下面的实玩全程纯输入驱动；tuning.gd 与玩家碰撞体未改动。 |

## 0:15.53 · B01 — BLUF — what was actually built
### 开门见山 —— 实际做出来的是什么

`23.20s` · Remotion 卡片 `BrutalistHesitantWriter`

**EN — spoken**

> Here is the honest framing. walker-link is not a game written from nothing.
> It is a fork of nikbearbrown slash walker-jumpman — the First Steps
> prototype, Godot four point seven point two. Two things in it belong to the
> fork. The player is redrawn as a green-capped adventurer carrying a sword
> and a shield. And the course grows a third section. The movement tuning, the
> collider, the controls, the retry loop and the original geometry all still
> belong to the starter.

**中文 — 对照译文**

> 先把话说清楚。walker-link 不是从零写出来的游戏。它是 nikbearbrown/walker-jumpman 的一个 fork —— 那个叫 First Steps 的原型，
> Godot 4.7.2。这个 fork 只拥有两样东西：玩家被重新画成一个戴绿帽、
> 带剑带盾的冒险者；关卡多出第三个区段。移动手感参数、碰撞体、操作键位、重试循环，
> 还有原本的几何布局——全都仍然属于 starter。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 打字 typed | walker-link is a game I wrote. / Two things in it are mine: / the character, / and one new level section. / The rest is the starter's. | walker-link 是我写的一个游戏。/ 其中有两样东西是我的：/ 角色，/ 以及一个新的关卡区段。/ 其余都是 starter 的。 |
| 自我更正 correction | “wrote” → “forked” |  |

## 0:38.73 · B02 — the starter course
### starter 原本的关卡

`8.93s` · 实拍 gameplay · `run-01` · f0–200 @1.0×, f116–134 @0.25×

**EN — spoken**

> Real engine, native four K. Every key here is pressed by a script — no
> teleports, no position edits. This first stretch is the starter's own
> course.

**中文 — 对照译文**

> 真实引擎，原生 4K。这里每一次按键都是脚本按下去的——没有传送，没有改坐标。
> 第一段路是 starter 自己的关卡。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.25× — the first gap | 回放 0.25× —— 第一个缺口 |

## 0:47.67 · B03 — the character
### 角色

`13.80s` · 实拍 gameplay · `run-05` · f0–100 @1.0×, f56–96 @0.25×, f100–186 @1.0× · 定格 68 帧（2.3s）

**EN — spoken**

> Change one: the character. Green cap, flared tunic, a shield on the leading
> arm, a sword behind. Turn around and every piece of it mirrors — slowed down
> here so you can see it. The sword tip reaches four and a half pixels past
> the collider. It is drawn, never solid.

**中文 — 对照译文**

> 改动之一：角色。绿色尖帽、下摆外扩的束腰短袍、前臂上的盾、身后的剑。转个身，
> 每一个部件都会镜像——这里放慢了，好让你看清。剑尖伸出碰撞体 4.5 像素。
> 它是画上去的，从来不是实体。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.25× — the turn, mirrored | 回放 0.25× —— 转身，整体镜像 |

## 1:01.47 · B04 — coyote time
### coyote time（土狼时间）

`12.60s` · 实拍 gameplay · `run-07` · f20–112 @1.0×, f78–102 @0.15×, f102–155 @1.0× · 定格 73 帧（2.4s）

**EN — spoken**

> The ground runs out at four forty-eight. The jump goes in two physics ticks
> after the floor is gone — and coyote time still pays it. Six ticks of
> forgiveness, one tenth of a second. That is the input log talking, not my
> eyes.

**中文 — 对照译文**

> 地面在 448 结束。起跳键是在脚下没路之后的第 2 个物理 tick 才按下去的——而 coyote time 照样认账。
> 6 个 tick 的宽容，十分之一秒。这是输入日志在说话，不是我的眼睛。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.15× — jump pressed after the edge | 回放 0.15× —— 起跳键按在离地之后 |

## 1:14.07 · B05 — no double jump, and the buffer
### 没有二段跳，以及输入缓冲

`9.90s` · 实拍 gameplay · `run-07` · f86–180 @1.0×, f88–100 @0.2×, f138–156 @0.2×, f180–197 @1.0× · 定格 36 帧（1.2s）

**EN — spoken**

> Press again in the air and nothing happens. There is one jump, and it is
> spent. But press it just before you land, and the buffer holds it for six
> ticks and fires it on the touchdown tick.

**中文 — 对照译文**

> 在空中再按一次，什么都不会发生。跳跃只有一次，而且已经用掉了。但如果你在快落地时按下去，
> 缓冲会替你按住 6 个 tick，然后在脚触地的那一 tick 把它放出来。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.2× — the refused second press | 回放 0.2× —— 被拒绝的第二次按键 |
| 烧录标签 label | REPLAY 0.2× — buffered, then landing | 回放 0.2× —— 缓冲，然后落地 |

## 1:23.97 · B06 — Section 03 — the step is a wall
### Section 03 —— 台阶是一堵墙

`11.27s` · 实拍 gameplay · `run-06` · f120–240 @1.0×, f178–200 @0.2×, f200–245 @1.0× · 定格 63 帧（2.1s）

**EN — spoken**

> Change two: Section 03. First thing in it is a spiked step. Walk into it and
> the run does not end — the body stops dead at nine eighty-three, against a
> face at nine ninety-two, and nothing kills you.

**中文 — 对照译文**

> 改动之二：Section 03。进去第一样东西是一段带尖刺的台阶。直接走上去撞它，
> 这一局不会结束——身体在 983 处停死，台阶的立面在 992，什么都没杀你。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.2× — blocked, not killed | 回放 0.2× —— 被挡住，没被杀死 |

## 1:35.23 · B07 — cause and effect — one source change
### 因果 —— 一处源码改动

`30.40s` · Remotion 卡片 `ClaudeCodeBeat`

**EN — spoken**

> That is a source change you can watch. In the starter, the spikes were
> painted at a hard-coded y of three hundred and twenty, while the trigger
> polygon was built from the hazard rect's own size. On flat ground nobody
> notices. Put spikes on a step twenty-four pixels up and the picture and the
> kill zone stop agreeing. Both now come out of one function, spike points, so
> the triangle you see is the triangle that kills. And the block is inset four
> pixels under the spikes on each side — which is exactly why walking into it
> stopped the run instead of ending it.

**中文 — 对照译文**

> 这是一处你能亲眼看见的源码改动。在 starter 里，尖刺被画在硬编码的 y = 320 上，
> 而触发多边形是按危险区矩形自己的尺寸算出来的。在平地上没人会发现。把尖刺放到一段抬高 24 像素的台阶上，
> 画面和杀伤区就对不上了。现在两者都出自同一个函数，spike points——所以你看见的那个三角形，
> 就是会杀死你的那个三角形。而且底下的方块比尖刺左右各宽出 4 像素——这正是为什么撞上去只是把这一局停住，
> 而不是终结它。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 点睛 spark | The drawing is the hitbox. | 画出来的那个形状，就是判定框。 |
| 代码 code | `godot/game/session.gd` — 见 `beat_sheet.json` | 见下 |

卡片上是 `godot/game/session.gd` 的真实代码。注释翻译：

* `# Before: the picture and the kill zone were computed separately.`
  —— 改动前：画面和杀伤区是分开算的。
* `#   _draw()     -> spikes painted at a literal y = 320, spaced i * 8`
  —— `_draw()` 把尖刺画在写死的 y = 320，间距 i × 8。
* `#   _add_area() -> trigger polygons built from rect.size.x / 3.0`
  —— `_add_area()` 用 `rect.size.x / 3.0` 生成触发多边形。
* `# Agreed on flat ground. Disagreed on a step 24 px above it.`
  —— 在平地上两者一致；在抬高 24 px 的台阶上就对不上了。
* `func _draw() -> void:   # what you see` —— 你看到的。
* `func _add_area(...) -> Area2D:  # what kills you` —— 杀死你的。
* `# hazard [996, 280, 24, 16] stands on block [992, 296, 32, 24]:`
  `# inset 4 px a side, so a body stopped by the face never reaches it.`
  —— 危险区站在方块上，左右各内缩 4 px，所以被立面挡住的身体永远碰不到触发器。

## 2:05.63 · B08 — Section 03 — hopping the step
### Section 03 —— 跳过台阶

`13.87s` · 实拍 gameplay · `run-06` · f214–310 @1.0×, f272–302 @0.15×, f302–338 @1.0× · 定格 84 帧（2.8s）

**EN — spoken**

> So you back up and hop it. Take off inside a twenty-four pixel window —
> measured, nine forty point six to nine sixty-four point six — and you land
> on the ground beyond. Never on the step: six take-offs across the range land
> on it zero times.

**中文 — 对照译文**

> 所以你往后退，再跳过去。起跳要落在一个 24 像素的窗口里——实测是 940.6 到 964.6——你就会落在台阶那一侧的地面上。
> 永远不会落在台阶上：在这个范围里扫了 6 次起跳，落到台阶上的次数是零。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.15× — the hop | 回放 0.15× —— 这一跳 |

## 2:19.50 · B09 — Section 03 — the stone, the chasm, the flag
### Section 03 —— 石头、深渊、旗子

`14.77s` · 实拍 gameplay · `run-01` · f196–290 @1.0×, f242–280 @0.15×, f280–312 @1.0× · 定格 64 帧（2.1s）

**EN — spoken**

> Then the part the section is really about. A forty pixel stone, and behind
> it a hundred and forty-four pixel chasm against a measured hundred and
> twelve pixel leap. You cannot jump the gap. You have to use the stone. Step
> up, step across, and the flag is on the far plateau.

**中文 — 对照译文**

> 接下来才是这个区段真正要讲的东西。一块 40 像素的石头，它后面是 144 像素的深渊，
> 而实测的最大跳跃距离是 112 像素。这个缺口你跳不过去。你必须踩石头。上去，
> 再跨过去，旗子在对面的高台上。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.15× — stone, then the crossing | 回放 0.15× —— 上石头，再跨过去 |

## 2:34.27 · B10 — failure and recovery — the spikes
### 失败与恢复 —— 尖刺

`16.53s` · 实拍 gameplay · `run-02` · f0–120 @1.0×, f84–118 @0.15×, f118–222 @1.0× · 定格 45 帧（1.5s）

**EN — spoken**

> Failure. This run starts from a click on the START button instead of Enter —
> the engine's recorder does not draw the cursor, so watch the card, not the
> pointer. Then I walk into the starter's spikes on purpose. Watch the spikes.
> Retries goes to one, and nought point five seven seconds later I am back at
> the start and clearing them.

**中文 — 对照译文**

> 失败。这一局是用鼠标点 START 按钮开始的，不是回车——引擎的录制器不会画光标，
> 所以看卡片，别找指针。然后我故意走进 starter 的那排尖刺。「Watch the spikes」
> 。重试计数变成 1，0.57 秒之后我回到起点，这次把它跳了过去。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.15× — contact, card, respawn | 回放 0.15× —— 接触、死亡卡、重生 |

## 2:50.80 · B11 — failure and recovery — the chasm
### 失败与恢复 —— 深渊

`17.43s` · 实拍 gameplay · `run-03` · f150–275 @1.0×, f214–252 @0.12×, f252–302 @1.0× · 定格 31 帧（1.0s）

**EN — spoken**

> The other way to lose. This take lands on the stone and then simply runs off
> the end of it — forty pixels is a step, not a place to stand. It clips the
> cliff face at twelve fifty-six, slides down, crosses the fall line at four
> hundred and thirty, and the game says: missed the landing. Same retry, same
> spawn, camera back to three twenty.

**中文 — 对照译文**

> 另一种输法。这一条 take 落在了石头上，然后就这么从石头另一头走了出去——40 像素是一级台阶，
> 不是一个可以站着思考的地方。它在 1256 蹭到崖面，滑下去，越过 430 那条坠落线，
> 游戏说：Missed the landing。同样的重试，同样的出生点，镜头退回 320。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.12× — off the stone, down the cliff | 回放 0.12× —— 走出石头，滑下崖面 |

## 3:08.23 · B12 — pause, restart, menu, focus
### 暂停、重开、菜单、焦点

`18.30s` · 实拍 gameplay · `run-04` · f0–300 @1.0×, f262–284 @0.2×, f284–367 @1.0× · 定格 56 帧（1.9s）

**EN — spoken**

> Everything around the run still works. Escape freezes the position and the
> clock — watch the timer stop. Enter resumes. R restarts the attempt and the
> retry counter does not move, because a restart is not a death. And when
> another application takes the keyboard — that is a real app switch, not a
> faked signal — the game pauses itself. M goes back to the menu.

**中文 — 对照译文**

> 这一局周围的东西也都还在工作。Esc 冻结位置和时钟——看计时器停住。回车继续。
> R 重开这一次尝试，而重试计数不动，因为重开不是死亡。而当另一个程序抢走键盘焦点——那是一次真实的应用切换，
> 不是伪造的信号——游戏会自己暂停。M 回主菜单。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.2× — another app takes the keyboard | 回放 0.2× —— 另一个程序抢走键盘 |

## 3:26.53 · B13 — the flag, the card, and again
### 旗子、结算卡，再来一遍

`11.63s` · 实拍 gameplay · `run-01` · f296–340 @1.0×, f304–328 @0.2×, f328–470 @1.0× · 定格 43 帧（1.4s）

**EN — spoken**

> And the end of it. The body overlaps the finish rect, the card reports the
> time and the retries, and Enter plays the whole thing again from a clean
> spawn. Eight point eight two seconds, zero retries, eight jumps.

**中文 — 对照译文**

> 然后是结尾。身体与终点矩形重叠，卡片报出时间和重试次数，回车让整个流程从干净的出生点再来一遍。
> 8.82 秒，0 次重试，8 次跳跃。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 烧录标签 label | REPLAY 0.2× — the body meets the finish rect | 回放 0.2× —— 身体与终点矩形相交 |

## 3:38.17 · BVD1 — verdict — what is settled
### 结论 —— 已经确定的

`30.50s` · Remotion 卡片 `ClaudeVerdictArtifact`

**EN — spoken**

> Verdict. Settled by machine: thirty-four mechanics checks and nine keyboard
> checks, zero failures, on Godot four point seven point two. Settled by
> playing: every implemented feature in this build, input-only, at revision
> one nine a seven d d d. The numbers are measured, not estimated — a fifty-
> six pixel jump, a nought point five seven second retry, a twenty-four pixel
> window over the step. And the starter's half is regression-tested unchanged:
> the tuning, the collider, the original geometry, all exactly as they were.

**中文 — 对照译文**

> 结论。机器能确定的：34 项机制检查加 9 项键盘检查，0 失败，在 Godot 4.7.2 上。
> 实玩能确定的：这个构建里每一个已实现的功能，纯输入驱动，版本 19a7ddd。
> 这些数字是测出来的，不是估的——56 像素的跳跃高度、0.57 秒的重试、台阶上 24 像素的起跳窗口。
> 而 starter 那一半是带回归测试、原封未动的：手感参数、碰撞体、原有几何，
> 全都和原来一模一样。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 标题 heading | What is settled | 已经确定的 |
| 条目 line | Machine-checked at this revision: 34 mechanics checks + 9 keyboard checks, 0 failures, Godot 4.7.2. | 本版本的机器检查：34 项机制检查 + 9 项键盘检查，0 失败，Godot 4.7.2。 |
| 条目 line | Shown here input-only at walker-link 19a7ddd (source snapshot 5e772438…): every implemented feature, no teleports, no state writes. | 此处展示的是 walker-link 19a7ddd（源码快照 5e772438…）的纯输入实玩：每一个已实现功能，无传送，无状态写入。 |
| 条目 line | Measured, not guessed: 56 px jump rise, 0.57 s auto-retry, 940.6–964.6 take-off window over the step, 144 px chasm against a 112 px leap. | 实测而非估算：跳跃升高 56 px，自动重试 0.57 s，台阶起跳窗口 940.6–964.6，144 px 深渊 对 112 px 最大跳距。 |
| 条目 line | The starter's half is regression-tested unchanged: tuning.gd, the 18×28 collider, the five original solids, the ground hazard and the spawn keep their exact values. | starter 那一半经回归测试、原封未动：tuning.gd、18×28 碰撞体、原有五个实体块、地面危险区和出生点都保持原值。 |
| 条目 line | Both new landings and both failure modes were played on camera — the step hop, the stone, the spikes, the chasm — and the flag, with 0 retries. | 两个新落点和两种失败方式都在镜头前实玩过 —— 跳台阶、踩石头、尖刺、深渊 —— 以及 0 次重试触旗。 |

## 4:08.67 · BVD2 — verdict — what is not, and who did what
### 结论 —— 尚未确定的，以及谁做了什么

`28.93s` · Remotion 卡片 `ClaudeVerdictArtifact`

**EN — spoken**

> Not settled: one playtester, and he wrote the thing. Nobody has told us
> whether the sword and the shield read as props or as hitbox, and no check
> can. Not built, and not claimed: cherries, the three-zone course, sound,
> settings, moving platforms, a web export. So the next improvement is not
> code. Put this in front of somebody who has never seen it, and write down
> where they die. The human owns intent, scope, art direction and every
> judgment of feel. The A I implemented the authorised work, measured it,
> captured it, and narrated it.

**中文 — 对照译文**

> 不能确定的：只有一个试玩者，而且这东西是他自己写的。没有人告诉我们那把剑和那面盾看起来像随身道具还是像判定框，
> 而这一点没有任何自动检查能回答。没做、也没宣称做了的：樱桃、三区关卡、音效、
> 设置、移动平台、Web 导出。所以下一步的改进不是代码。把它放到一个从没见过它的人面前，
> 记下他死在哪里。人类掌握意图、范围、美术方向，以及一切关于手感的判断。AI 实现被授权的工作，
> 测量它、录制它，并且讲解它。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 标题 heading | What is not settled, and who did what | 尚未确定的，以及谁做了什么 |
| 条目 line | Uncertain: one playtester, the author. No first-time completion times, and no fairness or fun verdict from anyone else. | 不确定：试玩者只有一人，即作者本人。没有首次通关时间，也没有任何第三方对公平性或乐趣的判断。 |
| 条目 line | Whether the sword and shield read as props rather than hitbox is prediction F6, still open — no automated check can settle it. | 剑和盾是否被读作随身道具而非判定框，是预测 F6，仍未结案 —— 没有任何自动检查能判定它。 |
| 条目 line | Not built, and not claimed: cherries, the three-zone course, sound, settings and remapping, moving platforms, the Web export. | 未构建、也未宣称：樱桃、三区关卡、音效、设置与按键重映射、移动平台、Web 导出。 |
| 条目 line | Next improvement: a first-time player, unobserved, with their death positions written down — not another automated check. | 下一步改进：找一个第一次玩的人，不在旁指导，把他每次死亡的位置记下来 —— 而不是再加一项自动检查。 |
| 条目 line | Human owns intent, scope, art direction and every judgment of feel. AI implemented the authorised work, measured it, captured it and narrated it. | 人类掌握意图、范围、美术方向和一切关于手感的判断。AI 实现被授权的工作，测量、录制并讲解它。 |

## 4:37.60 · BHTF — your turn handoff
### 轮到你了

`26.93s` · Remotion 卡片 `ClaudeComposerAsk`

**EN — spoken**

> Your turn. Here is the prompt — read it with me. Fork walker-link, keep
> tuning dot g d and the player collider byte for byte, and add a fourth
> section whose hardest jump is measured: print the take-off window in ticks
> instead of guessing it. The constraint is the exercise. If you cannot change
> the jump, you have to change the geometry — and then you have to measure it.
> My own arithmetic here was wrong by more than a factor of two, and the
> engine corrected me. Let it correct you. Liam, in for Bear.

**中文 — 对照译文**

> 轮到你了。这是提示词——跟我一起读。Fork walker-link，把 tuning.gd 和玩家碰撞体逐字节保留，
> 然后加上第四个区段，它最难的那一跳必须是测出来的：把起跳窗口按 tick 打印出来，
> 而不是猜。这个约束本身就是练习。如果你不能改跳跃，你就只能改几何——然后你就必须去测量它。
> 我自己在这里的算术错了不止两倍，是引擎纠正了我。也让它纠正你。Liam，替 Bear 出镜。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 问候 greeting | Your turn. | 轮到你了。 |
| 输入框 composer | Fork walker-link, keep tuning.gd and the player collider byte-for-byte, and add a fourth section whose hardest jump is measured — print the take-off window in ticks instead of guessing it. | Fork walker-link，把 tuning.gd 和玩家碰撞体逐字节保留，再加上第四个区段，它最难的那一跳必须是测出来的 —— 把起跳窗口按 tick 打印出来，不要靠猜。 |
| 运行行 running | paste this into your own Claude session… | 把这段粘进你自己的 Claude 会话…… |

## 5:04.53 · BOUT — outro
### 片尾

`5.00s` · Remotion 卡片 `ClaudeTitleOutro`

**无旁白。** 片尾卡静音：OUTRO-LOCK 指定的 jingle 在 `svg/claude/mp3/`，
本 checkout 里没有这个目录，已按 skill 要求记为资产阻塞而不是找替代品。

| 画面文字 | EN | 中文 |
| --- | --- | --- |
| 标题 title | Walker, Forked. | 《Walker, Forked.》（Walker，被 fork 了。） |
| 频道 handle | @NikBearBrown（硬编码） |  |
| 吉祥物 mascot | 由 slug `claude-liam-walker-link-walkthrough` 决定 |  |
| 副标题 subline | none — 永远没有 |  |

---

## 其余文本在哪 · where the rest lives

| | |
| --- | --- |
| 口播原文（唯一真源） | `beat_sheet.json` → `beats[].narration_text` |
| 卡片上的字 | `beat_sheet.json` → `beats[].shot.remotion.props` |
| 两段屏幕提示词及其性质 | `PROMPTS.md` |
| 每个口播数字的出处 | `FACTCHECK.md` |
| 每个 beat 的观察 → 解读 → 旁白 | `RIFF.md` |
| 每个 beat 用了哪条 take 的哪些帧 | `SHOTLIST.md` |
| 人工复核、时间码核验、资产阻塞 | `_qc/WALKTHROUGH-REVIEW.md` |
