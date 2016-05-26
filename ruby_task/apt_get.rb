require './fubuninit'
require './run_bash'

class AptGet
class << self
	def install(package_name)
		return true if package_installed?(package_name)
		run_bash("apt-get -y install #{package_name}")	
	end
	
	def install_deb(src, file_name=nil)
		if (/http(|s):\/\// =~ src)==0
			url = src


			file_name ||= url.split('/').last
			file_name += ".deb" if file_name[-3..-1] != "deb"
			install_file = "#{Fubuninit::TMP_DIR}/#{file_name}"
			
			unless File.exists? install_file
				run_bash("proxychains aria2c '#{url}' -d '#{Fubuninit::TMP_DIR}' -o #{file_name}")
			end
			src = install_file
		end
		# run_bash("dpkg -I #{chrome_file}")
		run_bash("dpkg -i #{install_file}")
		run_bash("apt-get -y install -f")

		$?.exitstatus
	end


	def package_installed?(package_name, bin_name=nil)
		bin_name ||= package_name
		["dpkg --get-selections | grep #{package_name}", 
		"which #{bin_name}"].each do |cmd|
			`#{cmd}`
			if $?.exitstatus == 0
				puts "#{bin_name} already installed"
				return true
			end
		end
		false
	end
end
end

