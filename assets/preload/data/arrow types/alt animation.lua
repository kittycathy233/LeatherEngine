function createPost()
    for i = 0,getUnspawnNotes()-1 do 
		if getUnspawnedNoteNoteType(i) == 'alt animation' then 
			setUnspawnedNoteSingAnimSuffix(i, "-alt")
		end
    end
end