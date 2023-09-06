EntranceEdit Ver1.01		by homing

Data.asm version by Chdata

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
level毎にヨッシー禁止画面で用いるマップを編集できるようにするパッチです。

例えばlevel105（元:ヨースター島コース１）のヨッシー禁止画面の設定を行うには、
Data.binのアドレス105の値を設定し、EntranceEdit.asmを導入します。
Data.binの値の示す意味は以下の通りです。


00　…　禁止画面無しにヨッシー禁止有効
	タイルセットにかかわらずヨッシー禁止を行いますが、禁止画面は表示しません。
	

01　…　デフォルト
	パッチ未導入時と同じ挙動をします。
	すなわちお化け屋敷のタイルセットに対してはお化け屋敷の入り口が、
	城のタイルセットに対しては城の入り口が表示されます。


02~FF　…　カスタム
	　 タイルセットにかかわらず、強制的にヨッシー禁止画面を表示します。
	　 このとき使われるマップは、ここで指定した値と同じlevel（002~0FF）となります。	　　


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

This patch allows you to edit "what map is used by castle entrance" for each level.

If you want to edit "castle entrance of level 105",
open the "Data.bin" with binary editor and edit address $000105 followingly.


00 ...	regardless of GFX tile set, prohibit yoshi without showing any entrance scenes.
	
	
01 ...	default behavior
	(same behavior to that before you apply this patch)

02-FF ... regardless of GFX tile set, force the entrance to be valid 
          and to use custom map (level002-0FF)