require 'spec_helper'
require 'coin'

describe Coin do
  let(:name)        { 'coin' }
  let(:change_owed) { 47 }
  let(:value)       { 1 }
  let(:ncoins)      { 1 }

  describe '#acceptable_change?' do
    subject do
      Coin.new(name, value).acceptable_change?(change_owed, ncoins)
    end
    context 'when the value is less than the amount owed' do
      it { should == true }
    end

    context 'when the value is the same as the amount owed' do
      let(:change_owed) { 1 }
      it { should == true }
    end

    context 'when the value is greater than the amount owed' do
      let(:value) { 50 }
      it { should == false }
    end

    context 'multiple coins' do
      let(:ncoins) { 15 }

      context 'when the value is less than the amount owed' do
        it { should == true }
      end

      context 'when the value is the same as the amount owed' do
        let(:change_owed) { 15 }
        it { should == true }
      end

      context 'when the value is greater than the amount owed' do
        let(:value) { 50 }
        it { should == false }
      end
    end
  end

  describe '#amount_covered' do
    subject do
      Coin.new(name, value).amount_covered(change_owed)
    end

    context 'when it can completely cover the amount' do
      it { should == change_owed }
    end

    context 'when it can only cover some of the amount' do
      let(:value) { 5 }
      it { should == 45 }
    end

    context 'when it can not cover any of the amount' do
      let(:value) { 50 }
      it { should == 0 }
    end

    describe '#increment calls from #amount_covered' do
      subject do
        coin = Coin.new(name, value)
        coin.amount_covered(change_owed)
        coin.count
      end

      context 'when it can completely cover the amount' do
        it { should == 47 }
      end

      context 'when it can only cover some of the amount' do
        let(:value) { 5 }
        it { should == 9 }
      end

      context 'when it can not cover any of the amount' do
        let(:value) { 50 }
        it { should == 0 }
      end
    end
  end

  describe '#to_s' do
    subject do
      coin = Coin.new(name, value)
      coin.amount_covered(change_owed)
      coin.to_s
    end

    context 'nothing is printed when no coins are used' do
      subject do
        Coin.new(name, value).to_s
      end

      it { should.nil? }
    end

    context 'it uses the pluralized name if multiple coins are used' do
      it { should == '47 coins' }
    end

    context 'it uses the singular name if one coin is used' do
      let(:change_owed) { 1 }
      it { should == '1 coin' }
    end
  end
end
