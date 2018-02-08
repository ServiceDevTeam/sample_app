require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    # signup_pathがGETできるか
    get signup_path
    # ユーザ登録した前後でUserの数が変わってないか？
    assert_no_difference 'User.count' do
      post users_path,
      params: {
        user: {
          name:  "",
          email: "user@invalid",
          password:              "foo",
          password_confirmation: "bar"
        }
      }
    end
    # エラーメッセージが正しく表示されているか？
    assert_template 'users/new'
    # class="field_with_errors"である<div>タグが存在するか
    assert_select 'div.field_with_errors'

    # id="error_explanation"である<div>タグが存在するか
    assert_select 'div#error_explanation' do
      # <div id="error_explanation">の中に、<ul>があるか
      assert_select 'ul' do
        # さらに<ul>の中に、Name can't be blankという<li>が存在するか
        assert_select 'li', 'Name can\'t be blank'
      end
      # class="alert alert-danger"である<div>タグの中身が"The form contains 4 errors."であるか
      assert_select "div.alert.alert-danger", "The form contains 4 errors."
    end
  end

end
