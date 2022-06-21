SEC_SIZE = 128

options = {
  "user" => "0",
  "pad" => "true",
}

while ARGV.length > 1
  parts = ARGV.shift.sub(/--/, "").split("=")
  options[parts[0]] = parts[1]
end

filename = ARGV.shift
bytes = File.open(filename, "r").read.unpack("C*")

puts "A:DOWNLOAD #{filename.split(File::SEPARATOR).last.upcase}"
puts "U#{options["user"]}"
print ":"

sum = 0

bytes.each do |byte|
  print byte.to_s(16).rjust(2, "0").upcase
  sum += byte
end

pad = 0

if options["pad"] == "true"
  pad = SEC_SIZE - (bytes.length % SEC_SIZE)

  pad.times do
    print "00"
  end
end

puts ">#{(bytes.length + pad).to_s(16)[-2..].rjust(2, "0")}#{sum.to_s(16)[-2..].rjust(2, "0")}".upcase
