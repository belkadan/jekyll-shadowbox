# Based on http://nybblr.com/posts/ruby-extension-html-truncation
# Modified by Jordy Rose for document fragments.

begin
  require 'nokogiri'
  require 'htmlentities'
 
  class String
  	def truncate_html(num_words = 30, opts = {})
  		opts = {:word_cut => true, :tail => "&hellip;"}.merge(opts)
  		tail = HTMLEntities.new.decode(opts[:tail])
	 
  		doc = Nokogiri::HTML::DocumentFragment.parse(self)
	 
  		current = doc.children.first
  		count = 0
	 
  		while true
  			# we found a text node
  			if current.is_a?(Nokogiri::XML::Text)
  				count += current.text.split.length
  				# we reached our limit, let's get outta here!
  				break if count > num_words
  				previous = current
  			end
	 
  			if current.children.length > 0
  				# this node has children, can't be a text node,
  				# lets descend and look for text nodes
  				current = current.children.first
  			elsif !current.next.nil?
  				#this has no children, but has a sibling, let's check it out
  				current = current.next
  			else
  				# we are the last child, we need to ascend until we are
  				# either done or find a sibling to continue on to
  				n = current.parent
  				while !n.nil? and n.next.nil?
  					n = n.parent
  				end
	 
  				# we've reached the top and found no more text nodes, break
  				if n.nil?
  					break;
  				else
  					current = n.next
  				end
  			end
  		end
	 
  		if count >= num_words
  		  unless count == num_words
  			new_content = current.text.split
			 
  		  # If we're here, the last text node we counted eclipsed the number of words
  		  # that we want, so we need to cut down on words.  The easiest way to think about
  		  # this is that without this node we'd have fewer words than the limit, so all
  		  # the previous words plus a limited number of words from this node are needed.
  		  # We simply need to figure out how many words are needed and grab that many.
  		  # Then we need to -subtract- an index, because the first word would be index zero.
		   
  		  # For example, given:
  		  # <p>Testing this HTML truncater.</p><p>To see if its working.</p>
  		  # Let's say I want 6 words.  The correct returned string would be:
  		  # <p>Testing this HTML truncater.</p><p>To see...</p>
  		  # All the words in both paragraphs = 9
  		  # The last paragraph is the one that breaks the limit.  How many words would we
  		  # have without it? 4.  But we want up to 6, so we might as well get that many.
  		  # 6 - 4 = 2, so we get 2 words from this node, but words #1-2 are indices #0-1, so
  		  # we subtract 1.  If this gives us -1, we want nothing from this node. So go back to
  		  # the previous node instead.
  		  index = num_words-(count-new_content.length)-1
  		  if index >= 0
  			new_content = new_content[0..index]
  			  current.content = new_content.join(' ') + tail
  			  else
  				current = previous
  				current.content = current.content + tail
  			end
  		  end
	 
  			# remove everything else
  			while !current.nil?
  				while !current.next.nil?
  					current.next.remove
  				end
  				current = current.parent
  			end
  		end
	 
  		# now we grab the html and not the text.
  		# we do first because nokogiri adds html and body tags
  		# which we don't want
  		truncated = doc.inner_html
		 
  		# if html_safe?
  		#	 truncated.html_safe
  		# else
  		#	 truncated
  		# end
  		truncated
  	end
  end
rescue LoadError
  # no Nokogiri/htmlentities, no HTML truncation!
end
