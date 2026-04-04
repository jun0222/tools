#!/usr/bin/env python3
"""
インターバル音声ファイル生成ツール
指定したインターバルと繰り返し回数で、数字を読み上げる音声ファイル（MP3）を生成します。
"""

import os
import sys
from gtts import gTTS
from pydub import AudioSegment
from pydub.generators import Sine
import tempfile


def generate_beep(duration_ms=200, frequency=800):
    """ビープ音を生成"""
    beep = Sine(frequency).to_audio_segment(duration=duration_ms)
    # 音量を調整
    beep = beep - 10  # 10dB下げる
    return beep


def generate_number_speech(number, lang='ja'):
    """数字を音声で読み上げたMP3を生成"""
    try:
        tts = gTTS(text=str(number), lang=lang)
        temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.mp3')
        temp_file.close()
        tts.save(temp_file.name)
        audio = AudioSegment.from_mp3(temp_file.name)
        os.unlink(temp_file.name)
        return audio
    except Exception as e:
        print(f"音声生成エラー（数字: {number}）: {e}")
        # エラー時はビープ音を返す
        return generate_beep()


def generate_interval_audio(interval_seconds, repeat_count, output_file='interval_audio.mp3'):
    """
    インターバル音声ファイルを生成

    Args:
        interval_seconds: インターバル秒数
        repeat_count: 繰り返し回数
        output_file: 出力ファイル名
    """
    print(f"音声ファイル生成開始...")
    print(f"  インターバル: {interval_seconds}秒")
    print(f"  繰り返し回数: {repeat_count}回")
    print(f"  総時間: {interval_seconds * repeat_count}秒 ({interval_seconds * repeat_count // 60}分{interval_seconds * repeat_count % 60}秒)")

    # 無音を生成
    silence = AudioSegment.silent(duration=interval_seconds * 1000)  # ミリ秒に変換

    # 全体のオーディオを初期化
    final_audio = AudioSegment.empty()

    for i in range(repeat_count):
        print(f"  [{i+1}/{repeat_count}] 生成中...", end='\r')

        # インターバル（無音）を追加
        final_audio += silence

        # 数字の読み上げ音声を生成
        number_audio = generate_number_speech(i + 1)
        final_audio += number_audio

    print()  # 改行

    # MP3として出力
    print(f"ファイル保存中: {output_file}")
    final_audio.export(output_file, format='mp3', bitrate='192k')

    # ファイルサイズを取得
    file_size = os.path.getsize(output_file)
    file_size_mb = file_size / (1024 * 1024)

    print(f"\n✅ 完了！")
    print(f"  出力ファイル: {output_file}")
    print(f"  ファイルサイズ: {file_size_mb:.2f} MB")
    print(f"  総時間: {len(final_audio) / 1000:.1f}秒")


def main():
    print("=" * 60)
    print("インターバル音声ファイル生成ツール")
    print("=" * 60)
    print()

    # ユーザー入力を取得
    try:
        interval = int(input("インターバル秒数を入力してください (例: 30): "))
        if interval < 1 or interval > 3600:
            print("エラー: インターバルは1〜3600秒の範囲で指定してください")
            sys.exit(1)

        repeat = int(input("繰り返し回数を入力してください (例: 10): "))
        if repeat < 1 or repeat > 1000:
            print("エラー: 繰り返し回数は1〜1000回の範囲で指定してください")
            sys.exit(1)

        # デフォルトのファイル名を生成
        default_filename = f"interval_{interval}s_x{repeat}.mp3"
        filename = input(f"出力ファイル名を入力してください (Enter でデフォルト: {default_filename}): ").strip()

        if not filename:
            filename = default_filename

        if not filename.endswith('.mp3'):
            filename += '.mp3'

        print()

        # 音声ファイル生成
        generate_interval_audio(interval, repeat, filename)

    except KeyboardInterrupt:
        print("\n\n中断されました")
        sys.exit(0)
    except ValueError:
        print("エラー: 数値を正しく入力してください")
        sys.exit(1)
    except Exception as e:
        print(f"エラーが発生しました: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
