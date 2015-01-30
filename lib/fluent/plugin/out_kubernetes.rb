require 'json'

module Fluent
  class KubernetesOutput < Output
    Fluent::Plugin.register_output('kubernetes', self)
    config_param :tag, :string
    config_param :docker_containers_path, :string, :default => '/var/lib/docker/containers'

    def configure(conf)
      super
      @info = {}
    end

    def emit(tag, es, chain)
      es.each do |time,record|
        id = get_container_id(tag)
        info = get_info(id) 
        tag = prepare_tag(info)
        record.merge!(info)
        Engine.emit(tag, time, record)
      end

      chain.next
    end

    private
    def prepare_tag(info)
      tag = @tag
      tag = tag.gsub(/\$\{container_name\}/, info['container_name'] || info['container_id'] || "")
      tag = tag.gsub(/\$\{k8s_container_name\}/, info['k8s_container_name'] || "")
      tag = tag.gsub(/\$\{k8s_pod_name\}/, info['k8s_pod_name'] || "")
      tag
    end

    def get_container_id(tag)
		begin
		  tag_parts = tag.split('.')
		  id = tag_parts[6]
		rescue Exception => e
		  puts "GOT ERROR", e
		  id = nil
		end
		id
    end

    def get_info(id)
      @info[id] = get_info_from_docker(id) unless @info.has_key? id
      @info[id]
    end


    def get_info_from_docker(id)
      info = {"container_id" => id}
      container_name = get_name_from_cfg(id)
      if container_name
        info["container_name"] = container_name
        if container_name.start_with?("k8s")
          puts "IS KUB"
          begin
            parts = container_name.split(".")
            info["k8s_container_name"] = parts[0].split("_")[1]
            info["k8s_pod_name"] = parts[1].split("_")[1]
          rescue Exception => e
          puts "GOT ERROR", e
          end
        end
      end
      info

    end


    def get_name_from_cfg(id)
      begin
        docker_cfg = JSON.parse(File.read("#{@docker_containers_path}/#{id}/config.json"))
        container_name = docker_cfg['Name'][1..-1]
      rescue
        container_name = nil
      end
      container_name
    end

  end
end
