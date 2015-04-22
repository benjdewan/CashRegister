require 'spec_helper'
require 'coin_array'

describe CoinArray do
  describe "#calculate_change" do
    let(:change_owed) { 100 }

    subject do
      CoinArray.new.calculate_change(change_owed).to_s
    end

    context "it uses the largest coin possible" do
      it { should == "1 dollar" }
    end

    context "when one coin cannot cover the change owed" do
      context "it uses the largest coins possible" do
        let(:change_owed) { 250 }
        it { should == "2 dollars,2 quarters" }
      end

      context "when a larger coin cannot be used it is ignored" do
        let(:change_owed) { 3 }
        it { should == "3 pennies" }
      end
    end
  end

  describe "#calculate_change_randomly" do
    let(:change_owed) { 100 }

    context "it provides exact change" do
      subject do
        coin_array = CoinArray.new.calculate_change_randomly(change_owed)
        coin_array.map { |coin| coin.count * coin.value }.inject(:+)
      end

      it { should == 100 }
    end
  end
end
