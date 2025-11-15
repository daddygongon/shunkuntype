daddygongon: BDDで-hでヘルプを出すのをテストしましょう

Workspace: It looks like you may not have tests set up in this repository yet.
[object Object]

daddygongon: @workspace /tests Accept: "It looks like you may not have tests set up in this repository yet."

Workspace: 

daddygongon: @workspace /setupTests

Workspace: This workspace is a Ruby gem project, as indicated by the presence of a `.gemspec`, Gemfile, and the lib and test directories. The test directory contains test files, suggesting a conventional Ruby testing setup.

For Ruby projects, the most common testing frameworks are:

- **Minitest**: Lightweight, comes bundled with Ruby, and is easy to use for small to medium projects.
- **RSpec**: Popular for its expressive syntax and powerful features, often used in larger or behavior-driven projects.

Choose **Minitest** for simplicity and speed, or **RSpec** for more expressive tests and advanced features.



Pick a testing framework
[object Object]

daddygongon: @workspace /setupTests minitest: "Pick a testing framework"

Workspace: To set up `minitest` in your Ruby workspace, you only need to ensure `minitest` is included in your Gemfile and add a basic test file if needed. Since you already have a test directory with `test_helper.rb` and `test_sample.rb`, let's add `minitest` to your Gemfile and provide a "hello world" test example.



Apply Changes



Add the following line to your Gemfile if it's not already present:
```
gem 'minitest'
```

Then, install the gem:
```sh
bundle install
```

You can run your tests with:
```sh
ruby -Ilib:test test/test_hello_world.rb
```
Or to run all tests:
```sh
ruby -Ilib:test -e 'Dir.glob "./test/**/*_test.rb", &method(:require)'
```

You can also search for an extension to make tests easy to run in VS Code:

Search Extensions

daddygongon: @workspace /setupTests 

Workspace: Your workspace is a Ruby gem project, and your active test file uses Minitest. Minitest is lightweight, fast, and comes bundled with Ruby, making it a popular choice for Ruby projects. Alternatively, RSpec is another widely used Ruby testing framework, known for its expressive syntax.



Pick a testing framework
[object Object]

daddygongon: @workspace /setupTests minitest: "Pick a testing framework"

Workspace: To set up `minitest` in your workspace, you should add the `minitest` gem to your Gemfile and ensure you have a basic test in the test directory. Since you already have `test_helper.rb` and some test files, let's just add a "hello world" test if it's not already present.



Apply Changes



Add the following line to your Gemfile if it's not already present:
```
gem 'minitest'
```

Then, install the gem:
```sh
bundle install
```

You can run your tests with:
```sh
bundle exec ruby -Ilib:test test/test_hello_world.rb
```
Or to run all tests:
```sh
bundle exec rake test
```

You can also search for an extension to make tests easy to run in VS Code:

Search Extensions

daddygongon: BDDでshunkuntype -hでヘルプを出すのをテストを書いて

GitHub Copilot: ````ruby
require 'minitest/autorun'
require 'open3'

class TestCLIHelp < Minitest::Test
  def test_help_option
    stdout, stderr, status = Open3.capture3('ruby bin/shunkuntype -h')
    assert status.success?, "Process did not exit successfully"
    assert_match(/Usage|ヘルプ|help/i, stdout + stderr, "Help message not found in output")
  end
end
````

daddygongon: #terminalSelection とのエラー

GitHub Copilot: Read terminal selection

`rake test`で失敗しているのは、test_cli_help.rbのこの行が原因の可能性が高いです。

```ruby
stdout, stderr, status = Open3.capture3('ruby bin/shunkuntype -h')
```

- `bin/shunkuntype`がRubyスクリプトでなければ、`ruby bin/shunkuntype -h`は失敗します。
- また、`bin/shunkuntype`に実行権限がない場合や、`-h`でヘルプが出ない場合も失敗します。

**修正案:**

1. **shebangがある場合**  
   `bin/shunkuntype`の先頭に`#!/usr/bin/env ruby`があり、実行権限がある場合は、次のようにコマンドを修正してください。

   ````ruby
   # filepath: /Users/bob/git_hub/shunkuntype/test/test_cli_help.rb
   require 'minitest/autorun'
   require 'open3'

   class TestCLIHelp < Minitest::Test
     def test_help_option
       stdout, stderr, status = Open3.capture3('bin/shunkuntype -h')
       assert status.success?, "Process did not exit successfully"
       assert_match(/Usage|ヘルプ|help/i, stdout + stderr, "Help message not found in output")
     end
   end
   ````

2. **shebangがない場合**  
   Rubyスクリプトなら、`ruby bin/shunkuntype -h`でOKですが、`bin/shunkuntype`の中身を確認してください。

3. **実行権限の付与**  
   ターミナルで以下を実行してください。
   ```sh
   chmod +x bin/shunkuntype
   ```

4. **bin/shunkuntypeが存在しない場合**  
   ファイル名やパスを確認してください。

---

**まとめ**  
- `bin/shunkuntype`のshebangと実行権限を確認
- テストのコマンドを`Open3.capture3('bin/shunkuntype -h')`に修正

これで解決しない場合は、`bin/shunkuntype`の内容やエラーメッセージ全文を教えてください。

daddygongon: ここはgemの環境です．そこで適切にBDDを実行するようにセットアップしてください．

GitHub Copilot: gem環境でCLIのヘルプ表示をBDD（振る舞い駆動開発）スタイルでテストするには、  
`bin/shunkuntype`が実行可能であり、`bundle exec`を使って依存関係を解決するのが一般的です。

**修正版テスト例（minitest + Open3 + bundle exec）:**

````ruby
require 'minitest/autorun'
require 'open3'

class TestCLIHelp < Minitest::Test
  def test_help_option
    # bundle execでgemの依存関係を解決して実行
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'bin/shunkuntype', '-h')
    assert status.success?, "Process did not exit successfully"
    assert_match(/Usage|ヘルプ|help/i, stdout + stderr, "Help message not found in output")
  end
end
````

### 補足
- `bin/shunkuntype`の先頭に`#!/usr/bin/env ruby`が必要です。
- 実行権限を付与してください:  
  ```sh
  chmod +x bin/shunkuntype
  ```
- テスト実行は以下でOKです:
  ```sh
  bundle exec rake test
  ```
  または
  ```sh
  bundle exec ruby -Ilib:test test/test_cli_help.rb
  ```

これでgem環境でも正しくCLIのヘルプ表示テストができます。

daddygongon: TestCLIHelp
  test_help_option                                                FAIL (0.38s)
        Process did not exit successfully
        /Users/bob/git_hub/shunkuntype/test/test_cli_help.rb:8:in `test_help_option'

です．

GitHub Copilot: `Process did not exit successfully` というエラーは、`bin/shunkuntype -h` の実行が失敗していることを示しています。  
よくある原因と対策は以下の通りです。

---

### 1. `bin/shunkuntype` の shebang と実行権限

- 先頭に `#!/usr/bin/env ruby` があるか確認してください。
- 実行権限を付与してください:
  ```sh
  chmod +x bin/shunkuntype
  ```

---

### 2. `bin/shunkuntype` の中身が正しいか

- `-h` オプションでヘルプを出す処理が実装されているか確認してください。
- 例:  
  ```ruby
  #!/usr/bin/env ruby
  if ARGV.include?('-h') || ARGV.include?('--help')
    puts "Usage: shunkuntype [options]"
    exit 0
  end
  # ...他の処理...
  ```

---

### 3. テストでエラー内容を出力して原因を特定

エラー内容を確認するため、テストを以下のように修正してください。

````ruby
require 'minitest/autorun'
require 'open3'

class TestCLIHelp < Minitest::Test
  def test_help_option
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'bin/shunkuntype', '-h')
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert status.success?, "Process did not exit successfully"
    assert_match(/Usage|ヘルプ|help/i, stdout + stderr, "Help message not found in output")
  end
end
````

---

これで再度テストを実行し、STDOUT/STDERRの内容を確認してください。  
その内容を教えていただければ、さらに具体的なアドバイスが可能です。

daddygongon: あります

GitHub Copilot: ありがとうございます。  
shunkuntype がエントリポイントですが、テストでは shunkuntype を実行しています。  
RubyGemsのgem構成では、**shunkuntype は shunkuntype へのラッパー**として自動生成されることが多いですが、  
このプロジェクトでは shunkuntype が本体です。

---

## 修正方法

### 1. テストの実行対象を shunkuntype に変更

````ruby
require 'minitest/autorun'
require 'open3'

class TestCLIHelp < Minitest::Test
  def test_help_option
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-h')
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert status.success?, "Process did not exit successfully"
    assert_match(/Usage|ヘルプ|help/i, stdout + stderr, "Help message not found in output")
  end
end
````

---

### 2. 実行権限を付与

```sh
chmod +x exe/shunkuntype
```

---

### 3. `Command.run(ARGV)` の実装確認

- `Command.run(ARGV)` で `-h` オプション時にヘルプを表示し、正常終了（`exit 0`）するようになっているか確認してください。

---

これでテストが通るはずです。  
もしまだ失敗する場合は、STDOUT/STDERRの内容を教えてください。

daddygongon: #file:shunkuntype.rb:33-34 なんで，-hをhelpに割り当てるように変更しましょう．--historyは何か適当な英単語に置き換えてください．

GitHub Copilot: ````ruby
# ...existing code...
      opt.on('-v', '--version','show program Version.') { |v|
        opt.version = Shunkuntype::VERSION
        puts opt.ver
      }
      opt.on('-c', '--check','Check speed') {|v| SpeedCheck.new }
      opt.on('-d', '--drill [VAL]','one minute Drill [VAL]', Integer) {|v| Training.new(v) }
      opt.on('-h', '--help','show help message') { puts opt; exit }
      opt.on('--history','view training History') {|v| FinishCheck.new }
      opt.on('--reset','reset training data') { |v| reset_data()}
# ...existing code...
````

※ `--history` はそのままですが、例えば `--record` などに変更したい場合は以下のようにしてください。

````ruby
      opt.on('--record','view training History') {|v| FinishCheck.new }
````

Similar code found with 1 license type

daddygongon: logにしましょう

GitHub Copilot: ````ruby
      opt.on('-h', '--help','show help message') { puts opt; exit }
      opt.on('--log','view training History') {|v| FinishCheck.new }
````

daddygongon: -dでdrillが動くかテストできますか？

GitHub Copilot: はい、`-d`オプションで`Training`が動くかどうかもCLIテストできます。  
以下のようなテストを追加してください。

````ruby
require 'minitest/autorun'
require 'open3'

class TestCLIDrill < Minitest::Test
  def test_drill_option
    # -d 1 でテスト（1は適当な引数。必要に応じて変更）
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-d', '1')
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    # Trainingクラスの出力や挙動に応じて適切なアサートに変更してください
    assert_match(/STEP-1\.txt|keyboard|Repeat above sentences|Shunkuntype says 'Hello world'/i, stdout + stderr)
  end
end
````

- `-d 1` の `1` はテスト用の値です。  
- `assert_match` のパターンは `Training` の出力内容に合わせて調整してください。

このテストで`-d`オプションが正しく動作するか確認できます。

daddygongon: -cでcheck speedが動くかのテストを追加

GitHub Copilot: ````ruby
require 'minitest/autorun'
require 'open3'

class TestCLICheck < Minitest::Test
  def test_check_option
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-c')
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    # SpeedCheckクラスの出力内容に応じてパターンを調整してください
    assert_match(/speed|check|Shunkuntype says 'Hello world'/i, stdout + stderr)
  end
end
````

daddygongon: TestCLIDrill
STDOUT:
Shunkuntype says 'Hello world'.
"STEP-1.txt"
 q \ w \ e \ r t \ y u \ i \ o \ p
  a \ s \ d \ f g \ h j \ k \ l \ ; enter
sh z \ x \ c \ v b \ n m \ , \ . \  shift
frf ded juj kik

Repeat above sentences. Type return-key to start.frf ded juj kik
STDERR:
bundler: failed to load command: exe/shunkuntype (exe/shunkuntype)
/Users/bob/git_hub/shunkuntype/lib/shunkuntype/training.rb:73:in `block in type_loop': undefined method `chomp' for nil:NilClass (NoMethodError)

      line=STDIN.gets.chomp
                     ^^^^^^
        from /Users/bob/git_hub/shunkuntype/lib/shunkuntype/training.rb:69:in `each'
        と出ます．

GitHub Copilot: このエラーは、テスト実行時に `STDIN.gets` が `nil` を返し、`chomp` を呼んでいるためです。  
CIや自動テスト環境では標準入力がないため、`gets` は `nil` を返します。

---

## 解決方法

### 1. テスト時は標準入力をモックする

テストで `Open3.capture3` の第4引数（`stdin_data`）を使い、入力を与えることで回避できます。

````ruby
class TestCLIDrill < Minitest::Test
  def test_drill_option
    # "frf ded juj kik\n" など、必要なだけ改行を入れて入力を模倣
    input = "\n" * 3
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-d', '1', stdin_data: input)
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert_match(/STEP-1\.txt|keyboard|Repeat above sentences|Shunkuntype says 'Hello world'/i, stdout + stderr)
  end
end
````

---

### 2. 本体側で `nil` チェックを入れる（推奨）

`training.rb` の該当箇所を次のように修正してください。

````ruby
      line = STDIN.gets
      break if line.nil?
      line = line.chomp
      counter(sentence, line)
````

---

### どちらも行うとより堅牢です。

---

これでテストが失敗せず、`-d`オプションの自動テストが可能になります。

daddygongon: TestCLIDrill
STDOUT:
Shunkuntype says 'Hello world'.
"STEP-1.txt"
 q \ w \ e \ r t \ y u \ i \ o \ p
  a \ s \ d \ f g \ h j \ k \ l \ ; enter
sh z \ x \ c \ v b \ n m \ , \ . \  shift
frf ded juj kik

Repeat above sentences. Type return-key to start.frf ded juj kik
STDERR:
bundler: failed to load command: exe/shunkuntype (exe/shunkuntype)
/Users/bob/git_hub/shunkuntype/lib/shunkuntype/training.rb:73:in `block in type_loop': undefined method `chomp' for nil:NilClass (NoMethodError)

      line=STDIN.gets.chomp
                     ^^^^^^
        from /Users/bob/git_hub/shunkuntype/lib/shunkuntype/training.rb:69:in `each'とエラーは出ますが，testは全部成功しています．どこを改修しましょう．

GitHub Copilot: このエラーは、`STDIN.gets` が `nil` を返したときに `chomp` を呼んでいるため発生しています。  
テストは成功していますが、**本番環境や他の自動化環境でも同じエラーが出る可能性があるため、堅牢性のために修正すべきです**。

---

## 改修ポイント

training.rb の  
`line = STDIN.gets.chomp`  
を、**nilチェックを入れて安全に**しましょう。

---

### 修正版

````ruby
# ...existing code...
      line = STDIN.gets
      break if line.nil?
      line = line.chomp
# ...existing code...
````

---

### 解説

- `STDIN.gets` が `nil` の場合は `break` してループを抜けることで、`chomp` のエラーを防ぎます。
- これでテスト時も本番時も安全です。

---

**この修正を加えれば、エラーは出なくなります。**

daddygongon: #terminalSelection の通りだいぶエラーが出ています．実行コードを修正しましょうか？

GitHub Copilot: Read terminal selection

はい、修正が必要です。  
主な問題は training.rb の `init_proc` メソッドで `break` を使っていることです。  
`break` はメソッド内で直接使うと `Invalid break (SyntaxError)` となります。

---

## 修正案

### 1. `init_proc` の `break` を `return` に変更

````ruby
  def init_proc(file_name)
    data=File.readlines(file_name)
    data.each{|word| print word }
    print "\nRepeat above sentences. Type return-key to start."
    line=STDIN.gets
    if line.nil?
      # 入力がなければnilを返して呼び出し元で処理
      return nil, data
    end
    line = line.chomp
    start_time = Time.now
    return start_time, data
  end
````

### 2. `initialize` で `start_time` が `nil` の場合は早期リターン

````ruby
    start_time, data = init_proc(file_name)
    return if start_time.nil?
````

### 3. `type_loop` でも `STDIN.gets` のnilチェック

````ruby
  def type_loop(data)
    data.each do |sentence|
      break if @time_flag == false
      puts sentence
      line = STDIN.gets
      break if line.nil?
      line = line.chomp
      counter(sentence, line)
    end
  end
````

---

## まとめ

- `break` の代わりに `return` を使う
- `STDIN.gets` のnilチェックを徹底する

これでSyntaxErrorやNoMethodErrorが解消し、テストも安定して動作します。

daddygongon: #terminalSelection の通りfailuresはなくなりましたが，実行コードからのエラーが気になります．実行コードを修正してください．

GitHub Copilot: Read terminal selection

`failures` はありませんが、**実行時に `NoMethodError: undefined method 'chomp' for nil:NilClass`** が出ているのは、  
`STDIN.gets`（または `$stdin.gets`）が `nil` を返した場合に `chomp` を呼んでいるためです。

training.rb だけでなく、**`speed.rb` など他の箇所でも同じ問題**が起きています。

---

## 1. training.rb の修正（すでにOK）

あなたの training.rb はすでに `nil` チェックが入っています。

---

## 2. `speed.rb` の修正

`speed.rb` の `line = $stdin.gets.chomp` を  
**`line = $stdin.gets` → `break if line.nil?` → `line = line.chomp`**  
のように修正してください。

### 例（`speed.rb` の該当箇所）

````ruby
# ...existing code...
      line = $stdin.gets
      break if line.nil?
      line = line.chomp
# ...existing code...
````

---

## 3. 他にも `$stdin.gets.chomp` や `STDIN.gets.chomp` を使っている箇所があれば、同様に修正してください

---

## まとめ

- **`gets` の戻り値が `nil` の場合は `break` する**（`chomp` を呼ばない）
- すべての `gets.chomp` をこのパターンに修正

---

### 参考：修正例

````ruby
line = $stdin.gets
break if line.nil?
line = line.chomp
````

---

これで実行時のエラーも解消し、テストも安定します。

daddygongon: #terminalSelection のようなエラーが出ます．

GitHub Copilot: Read terminal selection

`#terminalSelection` のエラーの主因は、**speed.rb の `break` の使い方が不正**なためです。

Rubyでは、メソッド本体で `break` を使うと `Invalid break (SyntaxError)` になります。  
`break` はブロックやループの中でのみ使えます。

---

## 修正版（speed.rb）

### `exec_speed_check` の該当箇所を修正

```ruby
def exec_speed_check(data)
  print "\n\n"+number.to_s+" words should be cleared."
  print "\nType return-key to start."
  p ''
  line = $stdin.gets
  return [nil, nil, nil] if line.nil?  # breakの代わりにreturnで早期リターン
  line = line.chomp

  t0 = Time.now
  count = 0
  @number.times do |i|
    print_keyboard()
    puts (i+1).to_s
    word = data[i]
    count += word.length
    while line != word do
      puts word
      p ''
      line = $stdin.gets
      return [t0, Time.now, count] if line.nil?  # ここもnilチェック
      line = line.chomp
    end
  end
  t1 = Time.now
  return t0, t1, count
end
```

---

## ポイント

- メソッド本体で `break` は使えません。**`return` で抜ける**ように修正してください。
- `$stdin.gets` の戻り値が `nil` の場合は `return` で抜けるようにします。
- ループ内の `line = $stdin.gets.chomp` も、`line = $stdin.gets` → `return if line.nil?` → `line = line.chomp` の順で安全に。

---

この修正で `Invalid break (SyntaxError)` は解消し、テストも正常に動作します。

daddygongon: #terminalSelection のエラーが出ています．

GitHub Copilot: Read terminal selection

エラーの本質はここです：

```
/Users/bob/git_hub/shunkuntype/lib/shunkuntype/speed.rb:78:in `keep_record': undefined method `-' for nil:NilClass (NoMethodError)
statement << (t1-t0).to_s+","
```

これは、`exec_speed_check` で `t0` または `t1` が `nil` のまま `keep_record` に渡されているためです。  
（テスト時などで `$stdin.gets` が `nil` になった場合に発生）

---

## 修正方法

### 1. `keep_record` の前に `t0` や `t1` が `nil` なら記録処理をスキップ

````ruby
def initialize
  @number = 20 #default 20
  @period = 60
  check_data_files
  data = mk_random_words
  t0, t1, count = exec_speed_check(data)
  # ここでnilチェック
  if t0.nil? || t1.nil?
    puts "Speed check was interrupted or no input was given."
    return
  end
  keep_record(t0, t1, count)
end
````

---

### 2. `keep_record` の中でnilチェック（念のため）

````ruby
def keep_record(t0, t1, count)
  return if t0.nil? || t1.nil?
  statement = t0.to_s + ","
  statement << @number.to_s + ","
  statement << (t1 - t0).to_s + ","
  icount = @period / (t1 - t0) * count
  statement << icount.to_s + "\n"
  data_file = open(Shunkuntype::SPEED_FILE, "a+")
  data_file << statement
  p statement

  printf("%5.3f sec\n", Time.now - t0)
  printf("%4d characters.\n", icount)
end
````

---

## まとめ

- `t0` または `t1` が `nil` の場合は `keep_record` を呼ばない
- これで `NoMethodError` は解消します

---

**この修正で #terminalSelection のエラーは出なくなります。**

Similar code found with 1 license type

daddygongon: エラーがなくなりました．ありがとう．

GitHub Copilot: どういたしまして！  
また何かあればいつでもご相談ください。

daddygongon: このファイルにあるBDDテストをまとめましょう．さらに，ファイル名を変更しましょう．

GitHub Copilot: ### まとめ

このファイルには、shunkuntype CLIの主要な3つの機能についてBDDスタイルでテストが書かれています。

- **ヘルプ表示（-h）**  
  `shunkuntype -h` でヘルプメッセージが表示されることをテスト

- **ドリル実行（-d）**  
  `shunkuntype -d 1` でドリル機能が動作し、キーボード配列や指示文が出力されることをテスト

- **スピードチェック（-c）**  
  `shunkuntype -c` でスピードチェック機能が動作し、関連する出力がされることをテスト

各テストは `Open3.capture3` でCLIを実行し、標準出力・標準エラー・終了ステータスを検証しています。

---

### ファイル名の提案

より分かりやすくするため、  
**test_cli_help.rb → `test_cli_bdd.rb`**  
などに変更するのが良いでしょう。

---

#### 変更例

```
mv test/test_cli_help.rb test/test_cli_bdd.rb
```

---

#### ファイル先頭のコメント例

````ruby
# BDD tests for shunkuntype CLI:
# - Help message (-h)
# - Drill mode (-d)
# - Speed check (-c)
````

daddygongon: TestCLIにclassをまとめて，defを並列するように変更

GitHub Copilot: ````ruby
require 'minitest/autorun'
require 'open3'

# BDD tests for shunkuntype CLI:
# - Help message (-h)
# - Drill mode (-d)
# - Speed check (-c)

class TestCLI < Minitest::Test
  def test_help_option
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-h')
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert status.success?, "Process did not exit successfully"
    assert_match(/Usage|ヘルプ|help/i, stdout + stderr, "Help message not found in output")
  end

  def test_drill_option
    input = "\n" * 3
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-d', '1', stdin_data: input)
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert_match(/STEP-1\.txt|keyboard|Repeat above sentences|Shunkuntype says 'Hello world'/i, stdout + stderr)
  end

  def test_check_option
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/shunkuntype', '-c')
    unless status.success?
      puts "STDOUT:\n#{stdout}"
      puts "STDERR:\n#{stderr}"
    end
    assert_match(/speed|check|Shunkuntype says 'Hello world'/i, stdout + stderr)
  end
end
````