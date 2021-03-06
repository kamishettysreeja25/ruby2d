# window.rb

module Ruby2D
  class Window
    attr_reader :title, :width, :height, :mouse_x, :mouse_y
    
    def initialize(width: 640, height: 480, title: "Ruby 2D", fps: 60, vsync: true)
      @width, @height, @title = width, height, title
      @mouse_x = @mouse_y = 0
      @fps_cap = fps
      @fps = 60
      @vsync = vsync
      
      @objects = []
      @keys = {}
      @keys_down = {}
      @controller = {}
      @update_proc = Proc.new {}
    end
    
    def get(sym)
      case sym
      when :window
        return self
      when :title
        return @title
      when :width
        return @width
      when :height
        return @height
      when :fps
        return @fps
      when :mouse_x
        return @mouse_x
      when :mouse_y
        return @mouse_y
      end
    end
    
    def set(opts)
      valid_keys = [:title, :width, :height]
      valid_opts = opts.reject { |k| !valid_keys.include?(k) }
      if !valid_opts.empty?
        @title = valid_opts[:title]
        @width = valid_opts[:width]
        @height = valid_opts[:height]
        return true
      else
        return false
      end
    end
    
    def add(o)
      case o
      when nil
        raise Error, "Cannot add '#{o.class}' to window!"
      when Array
        o.each { |x| add_object(x) }
      else
        add_object(o)
      end
    end
    
    def remove(o)
      if o == nil
        raise Error, "Cannot remove '#{o.class}' from window!"
      end
      
      if i = @objects.index(o)
        @objects.slice!(i)
        true
      else
        false
      end
    end
    
    def clear
      @objects.clear
    end
    
    def update(&proc)
      @update_proc = proc
      true
    end
    
    def on(mouse: nil, key: nil, key_down: nil, controller: nil, &proc)
      unless mouse.nil?
        # reg_mouse(btn, &proc)
      end
      
      unless key.nil?
        reg_key(key, &proc)
      end
      
      unless key_down.nil?
        reg_key_down(key_down, &proc)
      end
      
      unless controller.nil?
        reg_controller(controller, &proc)
      end
    end
    
    def key_callback(key)
      key.downcase!
      if @keys.has_key? key
        @keys[key].call
      end
    end
    
    def key_down_callback(key)
      key.downcase!
      if @keys_down.has_key? key
        @keys_down[key].call
      end
    end
    
    def controller_callback(is_axis, axis, val, is_btn, btn)
      
      # puts "is_axis: #{is_axis}, axis: #{axis}, val: #{val}, is_btn: #{is_btn}, btn: #{btn}"
      
      if is_axis
        if axis == 0 && val == -32768
          event = 'left'
        elsif axis == 0 && val == 32767
          event = 'right'
        elsif axis == 1 && val == -32768
          event = 'up'
        elsif axis == 1 && val == 32767
          event = 'down'
        end
      elsif is_btn
        event = btn
      end
      
      if @controller.has_key? event
        @controller[event].call
      end
    end
    
    def update_callback
      @update_proc.call
    end
    
    private
    
    def add_object(o)
      if !@objects.include?(o)
        @objects.push(o)
        true
      else
        false
      end
    end
    
    # Register key string with proc
    def reg_key(key, &proc)
      @keys[key] = proc
      true
    end
    
    # Register key string with proc
    def reg_key_down(key, &proc)
      @keys_down[key] = proc
      true
    end
    
    # Register controller string with proc
    def reg_controller(event, &proc)
      @controller[event] = proc
      true
    end
    
  end
end
