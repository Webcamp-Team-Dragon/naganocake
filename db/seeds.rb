# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# --Adminのseed設定--
# すでに同じメールアドレスのAdminが存在しないか確認
admin = Admin.find_or_initialize_by(email: 'admin@example.com')

# Adminが新規作成される場合、パスワードを設定
admin.password = 'admin12'
admin.password_confirmation = 'admin12'

# 変更があった場合にのみ保存する
if admin.new_record? || admin.changed?
  admin.save!
  puts "Admin user created or updated!"
else
  puts "Admin user already exists!"
end
# --Adminのseed設定ここまで--

# Customerのseed
Customer.create!(
  email: 'customer1@example.com',
  password: 'customer1',
  last_name: '顧客',
  first_name: '一号',
  last_name_kana: 'コキャク',
  first_name_kana: 'イチゴウ',
  postal_code: '0000000',
  telephone_number: '00000000000',
  address: 'サンプル県サンプル市サンプル島１丁目'
)

# ----------------------------------------------------------------------------------
# 動作確認のため下記追加しました。必要に応じてコメントアウトしてください！（田中）
# データベース内にあるseedのデータを削除する場合は、下記1)または2)を実行してください

# 1) rails db:resetを実行する
# 2)rails cを実行し、
# ・Item.delete_all
# ・Genre.delete_allの2つを実行する

# ジャンルのデータを作成
genres_data = [
  { name: 'ケーキ' },
  { name: '焼き菓子' },
  { name: 'プリン' },
  { name: 'キャンディ' }
]

genres_data.each do |genre_data|
  genre = Genre.find_or_create_by(name: genre_data[:name])  # find_or_create_byを使用して、ジャンルが存在しない場合のみ新しく作成します。
  puts "Genre '#{genre.name}' created or already exists!"
end

# アイテムのデータを作成
items_data = [
  { genre_name: 'ケーキ', name: 'いちごのショートケーキ（ホール）', introduction: 'いちごのショートケーキです。(seeds.rb内記述)', price: 2500, image_file: 'i_cake1.jpg' },
  { genre_name: 'ケーキ', name: 'ガトーショコラ', introduction: 'ガトーショコラです。(seeds.rb内記述)', price: 350, image_file: 'i_cake2.jpg' },
  { genre_name: '焼き菓子', name: 'クッキー', introduction: 'クッキーです。(seeds.rb内記述)', price: 300, image_file: 'i_cookie1.jpg' },
  { genre_name: 'プリン', name: 'チョコプリン', introduction: 'チョコプリンです。(seeds.rb内記述)', price: 250, image_file: 'i_pudding1.jpg' },
  { genre_name: 'キャンディ', name: '抹茶キャンディ', introduction: '抹茶のキャンディです(seeds.rb内記述)', price: 200, image_file: 'i_candy1.jpg' },
  { genre_name: 'ケーキ', name: 'チョコバナナミルフィーユ', introduction: 'チョコバナナミルフィーユです。(seeds.rb内記述)', price: 400, image_file: 'i_millefeuille1.jpg' },
  { genre_name: 'ケーキ', name: 'チーズタルト', introduction: 'チーズタルトです。(seeds.rb内記述)', price: 330, image_file: 'i_cake3.jpg' }
]

items_data.each do |item_data|
  genre = Genre.find_by(name: item_data[:genre_name])

  # アイテムがすでに存在するか確認。存在しない場合は新規作成、存在する場合は更新する形。
  item = Item.find_or_initialize_by(name: item_data[:name], genre_id: genre.id)

  # アイテムの属性を設定
  item.introduction = item_data[:introduction]
  item.price = item_data[:price]
  item.is_active = true

  # 画像ファイルを設定
  item.image = ActiveStorage::Blob.create_and_upload!(io: File.open("app/assets/images/#{item_data[:image_file]}"), filename: item_data[:image_file])

  item.save!
end