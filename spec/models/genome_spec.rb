require 'spec_helper'
require 'bio'

describe Genome do
  let(:organism) { 
    Organism.create!(
      :local_name => "My favourite organism",
      :genus => "Arabidopsis",
      :species => "thaliana",
      :strain => "Col 0",
      :pv => "A",
      :taxid  => "3702"
    ) 
  }

  let(:other_organism) { 
    Organism.create!(
      :local_name => "My mother's organism",
      :genus => "Ardisia",
      :species => "Myrsinaceae",
      :strain => "Col 10",
      :pv => "B",
      :taxid  => "1234"
    ) 
  }

  def valid_attributes(overrides={})
    {
      organism_id: organism.id,
      build_version: "TAIR 9",
      meta: {
        "institution" => 
          {
            "name" => "Your Institute",
            "logo" => "images/institute_logo.png",
            "url"  => "http://www.your_place.etc"
          }, 
        "service" => 
          {
            "format"  => "Unspecified", 
            "title"   => "Sample GeeFu served browser (TAIR 9 Gene Models)",
            "server"  => "Unspecified",
            "version" => "Vers 1",
            "access"  => "public",
            "description" => "Free text description of the service"
          }, 
        "engineer" => 
          {
            "name"  => "Mick Jagger",
            "email" => "street.fighting.man@stones.net"
          }, 
        "genome" => 
          {
            "version" => "TAIR9", 
            "description" => "Chr1 from TAIR9", 
            "species" => "Arabidopsis thaliana"
          }
      }.to_json,
      fasta_file: "dummy/not/actually/used/in/the/spec"
    }.merge(overrides)
  end

  it_behaves_like "a model with user audits"

  describe "#to_s" do
    subject { Genome.new(valid_attributes) }

    it "is the organism's local name / build version" do
      subject.to_s.should eq "My favourite organism / TAIR 9"
    end
  end

  describe "#to_fasta" do
    let(:fasta_file_path) { "#{Rails.root}/spec/example_files/fasta/short.fna" }

    subject { Genome.new(valid_attributes) }

    before(:each) do
      Bio::FastaFormat.open(fasta_file_path).each do |entry|
        seq                = entry.to_seq
        reference          = Reference.new(:name => entry.entry_id, :length => entry.length)
        sequence           = Sequence.new(:sequence => "#{seq.seq}")
        reference.sequence = sequence        
        subject.references << reference
      end
      subject.save!
    end

    it "streams its sequences in fasta format" do
      subject.to_fasta.should eq <<-FASTA
>Chr1
ccctaaaccctaaaccctaaaccctaaacctctgaatccttaatccctaaatccctaaat
ctttaaatcctacatccatgaatccctaaatacctaattccctaaacccgaaaccggttt
ctctggttgaaaatcattgtgtatataatgataattttatcgtttttatgtaattgctta
ttgttgtgtgtagattttttaaaaatatcatttgaggtcaatacaaatcctatttcttgt
ggttttctttccttcacttagctatggatggtttatcttcatttgttatattggatacaa
gctttgctacgatctacatttgggaatgtgagtctcttattgtaaccttagggttggttt
atctcaagaatcttattaattgtttggactgtttatgtttggacatttattgtcattctt
actcctttgtggaaatgtttgttctatcaatttatcttttgtgggaaaattatttagttg
tagggatgaagtctttcttcgttgttgttacgcttgtcatctcatctctcaatgatatgg
gatggtcctttagcatttattctgaagttcttctgcttgatgattttatccttagccaaa
aggattggtggtttgaagacacatcatatcaaaaaagctatcgcctcgacgatgctctat
ttctatccttgtagcacacattttggcactcaaaaaagtatttttagatgtttgttttgc
ttctttgaagtagtttctctttgcaaaattcctctttttttagagtgatttggatgattc
aagacttctcggtactgcaaagttcttccgcctgattaattatccattttacctttgtcg
tagatattaggtaatctgtaagtcaactcatatacaactcataatttaaaataaaattat
gatcgacacacgtttacacataaaatctgtaaatcaactcatatacccgttattcccaca
atcatatgctttctaaaagcaaaagtatatgtcaacaattggttataaattattagaagt
tttccacttatgacttaagaacttgtgaagcagaaagtggcaacaccccccacctccccc
ccccccccccaccccccaaattgagaagtcaattttatataatttaatcaaataaataag
tttatggttaagagttttttactctctttatttttctttttctttttgagacatactgaa
aaaagttgtaattattaatgatagttctgtgattcctccatgaatcacatctgcttgatt
FASTA
    end
  end

  describe "validations" do
    subject { Genome.new(valid_attributes) }

    it "sanity checks it is valid" do
      subject.should be_valid
    end

    it "isn't valid unless we have a build version" do
      subject.build_version = ""
      subject.should_not be_valid
    end

    it "isn't valid unless the build version is unique within genomes for this organism" do
      Genome.create!(valid_attributes)
      subject.save.should be_false
      subject.errors[:build_version].should include "Build version must be unique to a genome"
    end

    it "is valid if the build version is unique for a separate organism" do
      Genome.create!(valid_attributes(organism_id: other_organism.id))
      subject.save.should be_true
    end
  end

  describe "persistence", versioning: true do
    subject { Genome.new(valid_attributes) }

    before(:each) do
      subject.save!
    end

    it "belongs to an Organism" do
      Genome.find(subject.id).organism.should eq organism
    end
        
    it_behaves_like "a model with versioning" do
      let(:attributes_to_update) { 
        {
          build_version: "TAIR 10"
        }  
      }

      let(:changeset) { 
        {
          "build_version" => [ "TAIR 9", "TAIR 10" ]
        }
      }
    end
  end
end