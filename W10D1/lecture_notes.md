# Testing Rails
## Intro to Rails Testing & Model Tests
### General Setup
**Remember to watch your code fail before you start testing**
  - If you don't its really easy to get false positives where your tests don't fail
- You will need to install the following gems:
  - General testing
	- `shoulda-matchers`
	- `rspec-rails`
  - For model testing
	- `factory_bot_rails`
	- `faker`
  - For unit testing
	- `rails-controller-testing`
	- `launchy`
- These can normally go in just the testing environment but for this class its a good idea to put them in both development and testing because we may interact directly with some of the testing bits
- We should add the following to the `.rspec` file:
```ruby
--require spec_helper
--color
--format documentation
```
- `rails_helper.rb` and `spec_helper.rb` are both basically just a bunch of config options
- Rails ships with testing framework other than Rspec, its not as good so its not very popular
- Its a good idea to have rails automatically generate the testing files for new things you generate, you can do this with the following:
```ruby
#config/application.rb
config.generators do |g|
  g.test_frameword :rspec,
    :fixtures => false,
	:view_specs => true,
	:helper_specs => false,
	:routing_specs => false,
	:request_specs => false,
	:controller_specs => true
end
```
You will need to change the boolean values for what you want to test

- You need to also add the following to `spec/rails_helper.rb`
```ruby
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_frameword :rspec
	with.library :rails
  end
```
- Faker is cool and can be used to generate a bunch of random data to generate your models. Look at the documentation at all the cool things you can make

### Writing Specs
Rspec files in rails look like this
```ruby
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_length_of(:password).is_at_least(6) }

  

  describe 'uniqueness' do
    #before(:each) do
	#  User.Create!(
	#  email: 'bee@bee.com',
	#  password: 'beeeee'
	#  location: Location.create(name: "Bee Town")
	#)
	create(:user) #This uses the factory bot to create a user using the model we wrote
	#build(:user) #This version creates the user object but doesn't try to save it to the db
	end
	
	it { should validate_uniqueness_of(:email)
	it { should validate_uniqueness_of(:email)
  end
```
- Its rails convention to not create an instance of any of the models in the specs because they can get huge and bad, you should use `FactoryBot` instead

- For factory bot you will need to create a directory in the spec dir called factories
  - You will use this to create the objects
```ruby
#spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
	password { 'beeeeeee' }
	association :location, factory: :location # This references a different model with a different factory
  end
end
```
## Controller Testing
```ruby
RSpec.describe BleatsController, type: :controller do
  describe "GET #index" do
	it "renders the bleats index" do
	  get :index
	  expect(response.to render_template(:index)
	end
  end

  describe "GET #new" do
    it "render the bleats new"
	  allow(subject).to receive(:logged_id?).and_return(true) #The subject that is automatically set up is a controller instance.
	  # You need to set up things like the above if they fail for weird reasons
	  get :new
	  expect(response).to render_template(:new)
	end
  end
  
  describe "DELETE #destroy" do
    let(:bleat) { create(:bleat) }
	before(:each) do
	  allow(subject).to receive(:current_user).and_return(bleat.author)
	  delete :destroy, params: { id: bleat.id }
	end

    it "destroys the bleat" do
	  expect(Bleat.exists?(id: bleat.id).to be false
	end
  end
end
```
## Feature tests/Capybara Specs
- There are feature blocks and scenario blocks in capybara
```ruby
require 'rails_helper'

feature 'creating a bleat', type: :feature do

  before(:each) do
	user = create(:user)
	login_as(user)
  end

  scenario 'take a body' do
    hello_world_bleat
    expect(page).to have_content("Hello World!"
  end
end

feature 'bleats index', type: :feature do

  #let(:bleat) { create(:bleat) } #This let is lazy evaluated and isn't actually setup until its used
  let!(:bleat) { create(:bleat) } # `let!` is evaluated right away so it will be avaliable without explicitly calling it


  scenario 'lists bleats' do
	visit bleats_url
	expect(page).to have_content(bleat.body)
end
```
- Its good practice to use the `spec_helper.rb` to put code that you use multiple times
```ruby
#spec/spec_helper.rb
def login_as(user)
  visit new_session_url
  fill_in("Email", with: user.email)
  fill_in("Password", with: "hunter2")
  click_button("Log in!")
end

def hello_world_bleat
  visit new_bleat_url
  #save_and_open_page #This is very useful for debugging, it will do what the method name implies and save the page as an html file and open that page
  fill_in("Body", with: "Hello World!") #This will take either the label or the id of the input
  click_button("Create the bleat!")
end
```
**When you are writing the labels for input make sure you nest the actual input inside of the label or capybara won't be able to find the input**
 - You can also do:
```html
<label for="name-input">Name:</label>
<input id="name-input">
```
