require 'rails_helper'

describe 'タスク管理機能', type: :system do
  # ユーザーAとユーザーBを定義する
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  # ユーザーAのタスクを作成するタイミングで、user_aを利用する。この時点でuser_aがデータベースに登録される。
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

  # contextの内容が呼び出される前に実行(1つのdescribeの中に複数のcontextが存在する場合contextの外側のbeforeが呼ばれる)
  before do
    # ログインする
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      # before do で利用するlogin_userを定義する
      let(:login_user) { user_a }
      
      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

        it 'ユーザーAが作成したタスクが表示されない' do
        # ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end
end
