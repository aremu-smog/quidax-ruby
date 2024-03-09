# frozen_string_literal: true

RSpec.describe Quidax do
  it "has a version number" do
    expect(Quidax::VERSION).not_to be nil
  end

  it "creates a valid object with secret key" do
    quidax = Quidax.new("s3cr3tk3y")
    expect(quidax.secret_key).to eq("s3cr3tk3y")
  end

  it "should throw ArgumentError for too many arguments" do
    Quidax.new("secret", "another_key", "unexpecte_argument")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq(true)
  end

  it "should throw ArgumentError for too few arguments" do
    Quidax.new
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq(true)
  end
end
