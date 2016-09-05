namespace :init do
  desc "Initialize data"

  task :types => :environment do
    ActiveRecord::Base.transaction do
      %w{
      3/4番下車
      ﾎｰｽ位置
      4番よし
      第1ﾎｰｽのｵｽ持ち
      3番よし
      第1ﾎｰｽ
      真空開始
      第2ﾎｰｽのｵｽ持ち
      第2ﾎｰｽ
      真空完了
      機関戻り
      水出
      放水
      圧
      4番戻り
      3番戻り
      2番戻り
      }.each_with_index do |nm, index|
        type = Type.find_or_initialize_by(name: nm)
        type.weight = 10 + index * 10
        type.save!
      end
    end
  end
end