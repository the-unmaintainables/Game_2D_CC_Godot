extends LineEdit

# 許可する文字（英数字）以外のパターンを定義
# [^a-zA-Z0-9] は「a-z、A-Z、0-9 以外の文字」を意味します
const ALLOWED_CHARS_PATTERN = "[^0-9]"

# 正規表現オブジェクト
var regex = RegEx.new()

func _ready():
	regex = RegEx.new()
	 # 正規表現のコンパイルとエラーチェック
	var compile_error = regex.compile(ALLOWED_CHARS_PATTERN)
	if compile_error != OK:
		print("致命的エラー: RegExコンパイル失敗！コード:" + str(compile_error))
	
	# テキストが変更されるたびに _on_text_changed 関数を呼び出す
	var error = text_changed.connect(_on_text_changed)

func _on_text_changed(new_text: String):
	print("シグナル実行")
	# 現在のテキストを取得
	var current_text = get_text()
	print(get_text())
	
	# 許可されていない文字をすべて空文字列 ("") に置換（削除）
	# true は「すべてのマッチを置換する」フラグ
	#var cleaned_text = regex.sub(current_text, "", true)
	#var match_result = regex.search(current_text) 
	
	var next_text = ""
	
	for moji in current_text:
		if "A" <= moji && moji <= "Z":
			next_text += moji
		elif "a" <= moji && moji <= "z":
			next_text += moji
		elif "0" <= moji && moji <= "9":
			next_text += moji
		
	print(next_text)
	
	print("文字の置換")
	
	#print(current_text)
	#print(cleaned_text)
	
	# 処理後にテキストが変更された場合のみ更新
	if current_text != next_text:
		# クリーンアップされたテキストをLineEditに再設定
		set_text(next_text)
		
		# 連続入力でカーソル位置が狂うのを防ぐため、末尾に移動
		caret_column = next_text.length()
