EntranceEdit Ver1.01		by homing

Data.asm version by Chdata

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
level���Ƀ��b�V�[�֎~��ʂŗp����}�b�v��ҏW�ł���悤�ɂ���p�b�`�ł��B

�Ⴆ��level105�i��:���[�X�^�[���R�[�X�P�j�̃��b�V�[�֎~��ʂ̐ݒ���s���ɂ́A
Data.bin�̃A�h���X105�̒l��ݒ肵�AEntranceEdit.asm�𓱓����܂��B
Data.bin�̒l�̎����Ӗ��͈ȉ��̒ʂ�ł��B


00�@�c�@�֎~��ʖ����Ƀ��b�V�[�֎~�L��
	�^�C���Z�b�g�ɂ�����炸���b�V�[�֎~���s���܂����A�֎~��ʂ͕\�����܂���B
	

01�@�c�@�f�t�H���g
	�p�b�`���������Ɠ������������܂��B
	���Ȃ킿���������~�̃^�C���Z�b�g�ɑ΂��Ă͂��������~�̓�������A
	��̃^�C���Z�b�g�ɑ΂��Ă͏�̓�������\������܂��B


02~FF�@�c�@�J�X�^��
	�@ �^�C���Z�b�g�ɂ�����炸�A�����I�Ƀ��b�V�[�֎~��ʂ�\�����܂��B
	�@ ���̂Ƃ��g����}�b�v�́A�����Ŏw�肵���l�Ɠ���level�i002~0FF�j�ƂȂ�܂��B	�@�@


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

This patch allows you to edit "what map is used by castle entrance" for each level.

If you want to edit "castle entrance of level 105",
open the "Data.bin" with binary editor and edit address $000105 followingly.


00 ...	regardless of GFX tile set, prohibit yoshi without showing any entrance scenes.
	
	
01 ...	default behavior
	(same behavior to that before you apply this patch)

02-FF ... regardless of GFX tile set, force the entrance to be valid 
          and to use custom map (level002-0FF)