class Node
	attr_accessor :v, :w, :tw
	
	def initialize(v, w, tw)
		@v = v
		@w = w
		@tw = tw
	end

end

def rws_heap(items)
	# h is the heap. It's like a binary tree that lives in an array.
	# It has a Node for each pair in `items`. h[1] is the root. Each
	# other Node h[i] has a parent at h[i>>1]. Each node has up to 2
	# children, h[i<<1] and h[(i<<1)+1].  To get this nice simple
	# arithmetic, we have to leave h[0] vacant.
	h = [nil]
	items.each do |v,w,k|
		h << Node.new(v, w, w)
	end
	(2..(h.size-1)).to_a.reverse.each do |i|
		h[i >> 1].tw += h[i].tw
	end
	return h
end

def rws_heap_pop(h)
	gas = h[1].tw * rand()			# start with a random amount of gas
	i = 1											# start driving at the root
	while gas > h[i].w				# while we have enough gas to get past node i:
		gas -= h[i].w						#   drive past node i
		i = i << 1							#   move to first child
		if gas > h[i].tw				#   if we have enough gas:
			gas -= h[i].tw				#     drive past first child and descendants
			i += 1								#     move to second child
		end
	end
	w = h[i].w								# out of gas! h[i] is the selected node.
	v = h[i].v
	
	h[i].w = 0								# make sure this node isn't chosen again
	while i > 0								# fix up total weights
		h[i].tw -= w
		i = i >> 1
	end
	return [v,w]
end

def random_weighted_sample_no_replacement(items, n)
	heap = rws_heap(items)
	lst = []
	(0..(n-1)).to_a.each do |i|
		lst << rws_heap_pop(heap)
	end
	return lst
end

#def weighted_sample(items, n)
#	total = items.map {|k,v| v}.sum.to_f
#	w, v = items[0]
#	lst = []
#	i = 0
#	while n > 0
#		x = total * (1 - rand() ** (1.0/n))
#		total -= x
#		while x > v
#			x -= v
#			i += 1
#			w, v = items[i]
#		end
#		v -= x
#		lst << w
#		n -= 1
#	end
#	return lst
#end


