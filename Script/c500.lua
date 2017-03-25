--created & coded by Lyris
--スペーシュル召喚
function c500.initial_effect(c)
	if not c500.global_check then
		c500.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(c500.op)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EFFECT_SEND_REPLACE)
		ge2:SetTarget(c500.repop)
		ge2:SetValue(c500.repfilter)
		Duel.RegisterEffect(ge2,0)
	end
end
function c500.regfilter(c)
	return c.spatial
end
function c500.amafilter(c)
	return c:GetOriginalCode()==47594939
end
function c500.nlrfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsStatus(STATUS_NO_LEVEL)
end
function c500.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c500.regfilter,0,0xff,0xff,nil)
	local tc=g:GetFirst()
	local n=1
	while tc do
		if tc:IsLocation(LOCATION_DECK) then Duel.DisableShuffleCheck() Duel.SendtoGrave(tc,REASON_RULE) Duel.SendtoHand(tc,nil,REASON_RULE) end
		if tc:IsLocation(LOCATION_HAND) then Duel.SendtoGrave(tc,REASON_RULE) Duel.Draw(tp,1,REASON_RULE) Duel.SendtoDeck(tc,nil,0,REASON_RULE) end
		if tc:GetFlagEffect(500)==0 then
			local ge1=Effect.CreateEffect(tc)
			ge1:SetType(EFFECT_TYPE_SINGLE)
			if tc.spatial_only then
				ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			else
				ge1:SetRange(LOCATION_EXTRA)
				ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
			end
			ge1:SetCode(EFFECT_SPSUMMON_CONDITION)
			ge1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			ge1:SetValue(c500.splimit)
			tc:RegisterEffect(ge1)
			local ge2=Effect.CreateEffect(tc)
			ge2:SetType(EFFECT_TYPE_FIELD)
			ge2:SetCode(EFFECT_SPSUMMON_PROC)
			ge2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			ge2:SetRange(LOCATION_EXTRA)
			ge2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			ge2:SetCondition(c500.sptcon)
			ge2:SetOperation(c500.sptop)
			ge2:SetValue(0x4000)
			tc:RegisterEffect(ge2)
			if tc.alterf then
				local ge3=ge2:Clone()
				ge3:SetDescription(tc.altdesc)
				ge3:SetCondition(c500.sptacon)
				ge3:SetOperation(c500.sptaop)
				tc:RegisterEffect(ge3)
			end
			local ge4=Effect.CreateEffect(tc)
			ge4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			ge4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
			ge4:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			ge4:SetOperation(
			function(e)
				local tc=e:GetHandler()
				if bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL+0x4000)==SUMMON_TYPE_SPECIAL+0x4000 then
					tc:CompleteProcedure()
					local e0=Effect.CreateEffect(tc)
					e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e0:SetCode(EVENT_CHAINING)
					e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e0:SetRange(LOCATION_MZONE)
					e0:SetLabel(0)
					e0:SetReset(RESET_EVENT+0x1fe0000)
					e0:SetOperation(c500.valcon)
					tc:RegisterEffect(e0)
					if c.effect_limit and c.effect_limit(e)==0 then
						local e1=Effect.CreateEffect(tc)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CANNOT_TRIGGER)
						e1:SetReset(RESET_EVENT+0x1fe0000)
						tc:RegisterEffect(e1)
					end
				else
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e1)
				end
			end)
			tc:RegisterEffect(ge4)
			local ge5=ge4:Clone()
			ge5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
			tc:RegisterEffect(ge5)
			local ge6=Effect.CreateEffect(tc)
			ge6:SetType(EFFECT_TYPE_SINGLE)
			ge6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
			ge6:SetCode(EFFECT_REMOVE_TYPE)
			ge6:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			ge6:SetValue(TYPE_XYZ)
			tc:RegisterEffect(ge6)
			if tc.relay then
				local ge7=Effect.CreateEffect(tc)
				ge7:SetType(EFFECT_TYPE_SINGLE)
				ge7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				ge7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				ge7:SetReset(RESET_EVENT+EVENT_ADJUST,1)
				ge7:SetValue(1)
				tc:RegisterEffect(ge7)
				if tc.negative_dimension then
					local ge8=Effect.CreateEffect(tc)
					ge8:SetType(EFFECT_TYPE_SINGLE)
					ge8:SetCode(EFFECT_ALLOW_NEGATIVE)
					ge8:SetRange(LOCATION_MZONE)
					ge8:SetReset(RESET_EVENT+EVENT_ADJUST,1)
					tc:RegisterEffect(ge8)
					local ge9=Effect.CreateEffect(tc)
					ge9:SetType(EFFECT_TYPE_SINGLE)
					ge9:SetCode(EFFECT_CHANGE_RANK)
					ge9:SetRange(LOCATION_MZONE)
					ge9:SetValue(function(e) return e:GetHandler():GetRank()*-1 end)
					ge9:SetReset(RESET_EVENT+EVENT_ADJUST,1)
					tc:RegisterEffect(ge9)
				end
			else
				tc:SetStatus(STATUS_NO_LEVEL,true)
			end
			tc:RegisterFlagEffect(500,RESET_EVENT+EVENT_ADJUST,0,1)
		end
		tc=g:GetNext()
	end
	if Duel.GetFlagEffect(0,47594939)==0 and Duel.IsExistingMatchingCard(c500.nlrfilter,tp,0xff,0xff,1,nil) then
		local g=Duel.GetMatchingGroup(c500.amafilter,tp,0xdf,0xdf,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoDeck(g,nil,-2,REASON_RULE)
		Duel.RegisterFlagEffect(0,47594939,0,0,1)
	end
end
function c500.repfilter(c)
	return c.spatial and bit.band(c:GetLocation(),LOCATION_REMOVED)==0 and c:GetDestination()==LOCATION_GRAVE
end
function c500.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c500.repfilter,1,nil) end
	local g=eg:Filter(c500.repfilter,nil)
	Duel.Remove(g,POS_FACEUP,r)
end
function c500.splimit(e,se,sp,st)
	return bit.band(st,0x4000)==0x4000
end
function c500.sptfilter1(c,tp,djn,f,sc)
	local lv=c:GetLevel()
	if c.spatial_level then lv=c.spatial_level(c,sc) end
	return c:IsFaceup() and lv and lv>0 and (not f or f(c)) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c500.sptfilter2,tp,LOCATION_MZONE,0,1,c,djn,f,c:GetAttribute(),c:GetRace(),lv,sc)
end
function c500.sptfilter2(c,djn,f,at,rc,tlv,sc)
	local lv=c:GetLevel()
	if c.spatial_level then lv=c.spatial_level(c,sc) end
	return c:IsFaceup() and c:GetAttribute()==at and c:GetRace()==rc
		and c:GetLevel()>0 and (djn==tlv or djn==lv)
		and (not f or f(c)) and c:IsAbleToRemove()
end
function c500.sptcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local rt=1
	local x=c.dimensional_number_o
	if c.relay then x=c:GetOriginalRank() end
	return ct<rt and Duel.IsExistingMatchingCard(c500.sptfilter1,tp,LOCATION_MZONE,0,1,nil,tp,x,c.material,c)
end
function c500.sptop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local rt=1
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local x=c.dimensional_number_o
	if c.relay then x=c:GetOriginalRank() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m1=mg:FilterSelect(tp,c500.sptfilter1,1,1,nil,tp,x,c.material,c)
	local tc=m1:GetFirst()
	local lv=tc:GetLevel()
	if tc.spatial_level then lv=tc.spatial_level(tc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m2=mg:FilterSelect(tp,c500.sptfilter2,1,1,tc,x,c.material,tc:GetAttribute(),tc:GetRace(),lv,c)
	m1:Merge(m2)
	c:SetMaterial(m1)
	Duel.Remove(m1,POS_FACEUP,REASON_MATERIAL+0x400000)
end
function c500.sptafilter(c,alterf)
	return c:IsFaceup() and alterf(c) and c:IsAbleToRemove()
end
function c500.sptacon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	e:SetLabelObject(mg)
	return ct<1 and c.alterf and mg:IsExists(c500.sptafilter,1,nil,c.alterf)
		and (not c.alterop or c.alterop(e,tp,0))
end
function c500.sptaop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=Duel.SelectMatchingCard(tp,c500.sptafilter,tp,LOCATION_MZONE,0,1,1,nil,c.alterf)
	if c.alterop then
		e:SetLabelObject(mg)
		local mc=c.alterop(e,tp,1)
		mg:Merge(mc)
	end
	c:SetMaterial(mg)
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+0x400000)
end
function c500.valcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re==e or re:GetHandler()~=c then return end
	local n=1
	local rk=c.dimensional_number
	if c.relay then x=c:GetOriginalRank() end
	if rk>4 then n=n+1 end
	if rk>6 then n=n+1 end
	if c.effect_limit then
		if not c.effect_limit(e) then return
		elseif c.effect_limit(e)>0 then n=c.effect_limit(e)
		else return end
	end
	e:SetLabel(e:GetLabel()+1)
	if n>e:GetLabel() then return end
	if c:IsOnField() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
