RSpec.describe Cem do
  it "has a version number" do
    expect(Cem::VERSION).not_to be nil
  end
  
  it "can check if a tag is valid in HTML 5" do
    
    expect(isHTML5Element("a")).to be(true)
    expect(isHTML5Element("A")).to be(true)
    
    expect(isHTML5Element(" A")).to be(false)
    expect(isHTML5Element("ahref")).to be(false)
    
    expect(isHTML5Element("applet")).to be(false)
  end  
  
  it "monkey-patches Numeric with all Math functions" do
    expect(3.sqrt).to eq(Math.sqrt(3))
    expect(3.14.sqrt).to eq(Math.sqrt(3.14))
  end
  
  it "provides min()" do 
    expect(Cem.min(1,2)).to eq(1)
    expect(Cem.min(2,1)).to eq(1)
    expect(Cem.min(1,1)).to eq(1)
    expect(Cem.min(-3,3)).to eq(-3)
    expect(Cem.min(3,-3)).to eq(-3)
    expect(Cem.min(1.5,1.0)).to eq(1.0)    
  end
end

RSpec.describe Point2D do
  
  let(:p) { Point2D.new(2,5) }
  let(:r) { Point2D.new(2,1) }
  let(:q) { Point2D.new(1,3) }
  
  describe "#to_s" do
  
    it { expect(p.to_s).to eq("2,5") }
    
  end
    
  describe "#flip" do
  
    it { expect(p.flip).to eq(Point2D.new(-2,-5)) } 
    
    it { expect(p.flip.flip).to eq(p) } 
  
  end 
    
  describe "#+" do
  
    it "allows to add other points" do 
      expect(p + q).to eq(Point2D.new(p.x + q.x, p.y + q.y))
    end
    
    it "allows adding arrays" do      
      expect(p + [q,r]).to eq([p+q, p+r])
    end
  end  
  
  describe "#*" do
    it "provides for scalar multiplication" do 
      expect(p * 3).to eq(Point2D.new(p.x * 3, p.y * 3))
    end  
  end 
  
  describe "#min" do
    it "returns the minimum coordinate wise of two points" do 
      expect(p.min(q)).to eq(q)
    end
    
    it "supports arrays as input" do
      expect(p.min([q])).to eq(q)
      expect(p.min([q, q, p])).to eq(q)
    end  
    
    it "works with nil" do
      expect(p.min(nil)).to eq(p)
      expect(p.min([nil])).to eq(p)
    end 
  end 
  
  describe "#max" do
    it "returns the maximum coordinate wise of two points" do 
      expect(p.max(q)).to eq(p)
    end
    
    it "supports arrays as input" do
      expect(p.max([q])).to eq(p)
      expect(p.max([q, q, p])).to eq(p)
    end  
    
    it "works with nil" do
      expect(p.max(nil)).to eq(p)
      expect(p.max([nil])).to eq(p)
    end 
  end 
  
  describe "#minmax" do
    it "returns the maximum coordinate wise of two points" do 
      expect(p.minmax(q)).to eq([q, p])
    end
    
    it "supports arrays as input" do
      expect(p.minmax([q, p, q])).to eq([q, p])
    end  
    
    it "works with nil" do
      expect(p.minmax([nil])).to eq([p, p])
      expect(p.minmax(nil)).to eq([p, p])
    end 
    
    it "also available globally" do
      expect(Point2D.minmax([q, p, q])).to eq([q, p])
      expect(Point2D.minmax([])).to eq([nil, nil])
    end 
  end 
      
  it "can parse common coordinates into Point2D" do
  
    expect(Point2D.from_s("^")).to eq(Dir2D::UP)
    
  end
  
end
