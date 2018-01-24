
return function(schedule)
    
    schedule:command('orhub/three'):every(3)
    schedule:command('orhub/four'):every(4)
    schedule:command('orhub/five'):every(5)
end

