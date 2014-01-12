describe Bosh::Manifests::Manifest do
  subject { Bosh::Manifests::Manifest.new manifest_file }
  let(:manifest_file) { get_tmp_file_path(manifest) }
  let(:name) { "foo" }
  let(:templates) { ["path_to_bar", "path_to_baz"] }
  let(:meta) { { "foo" => "bar" } }
  let(:uuid) { "foo-bar-uuid" }
  let(:manifest) { {
      "name" => name,
      "templates" => templates,
      "meta" => meta,
      "director_uuid" => uuid
    }.to_yaml }

  context "invalid manifest" do
    context "not a hash" do
      let(:manifest) { "foo" }
      it "raises an error" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors).to eq ["Manifest should be a hash"]
      end
    end

    context "missing name" do
      let(:manifest) { {
          "templates" => templates, "director_uuid" => uuid, "meta" => meta
        }.to_yaml }
      it "raises an error" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors).to eq ["Manifest should contain a name"]
      end
    end

    context "missing templates" do
      let(:manifest) { {
          "name" => name, "director_uuid" => uuid, "meta" => meta }.to_yaml }
      it "raises an error" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors).to eq ["Manifest should contain templates"]
      end
    end

    context "missing director_uuid" do
      let(:manifest) { {
          "name" => name, "templates" => templates, "meta" => meta }.to_yaml }
      it "raises an error" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors).to eq ["Manifest should contain a director_uuid"]
      end
    end

    context "missing meta" do
      let(:manifest) { {
          "name" => name, "templates" => templates, "director_uuid" => uuid
        }.to_yaml }
      it "raises an error" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors).to eq ["Manifest should contain meta hash"]
      end
    end
  end

  context "valid manifest" do
    it { should be_valid }

    it "has properties" do
      subject.validate
      expect(subject.name).to eq name
      expect(subject.templates).to eq templates
      expect(subject.meta).to eq meta
      expect(subject.filename).to eq "tmp"
      expect(subject.director_uuid).to eq uuid
    end
  end
end
