RSpec.describe Bitcoin::P2P do
  it "has a version number" do
    expect(Bitcoin::P2P::VERSION).not_to be nil
  end
end
