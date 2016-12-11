--Spatial Procedure
function c500.initial_effect(c)
	if not c500.global_check then
		c500.global_check=true
		--register
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetOperation(c500.op)
		Duel.RegisterEffect(e0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetTarget(c500.repop)
		e1:SetValue(c500.repfilter)
		Duel.RegisterEffect(e1,0)
	end
end
function c500.regfilter(c)
	return c.spatial
end
function c500.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c500.regfilter,0,0xff,0xff,nil)
	local tc=g:GetFirst()
	local n=1
	while tc do
		if tc:IsLocation(LOCATION_DECK) then Duel.DisableShuffleCheck() Duel.SendtoHand(tc,nil,REASON_RULE) end
		if tc:GetFlagEffect(500)==0 then
			tc:EnableReviveLimit()
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e0:SetCode(EFFECT_SPSUMMON_CONDITION)
			e0:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e0:SetValue(c500.splimit)
			c:RegisterEffect(e0)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e1:SetCondition(c500.sptcon)
			e1:SetOperation(c500.sptop)
			e1:SetValue(0x4000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e2:SetCondition(function(e) return bit.band(e:GetHandler():GetSummonType(),0x4000)==0x4000 end)
			e2:SetOperation(function(e) e:GetHandler():CompleteProcedure() end)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCode(EFFECT_REMOVE_TYPE)
			e3:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e3:SetValue(TYPE_XYZ)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e4:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e4:SetValue(1)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(tc)
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EFFECT_DESTROY_REPLACE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e5:SetRange(LOCATION_MZONE)
			e5:SetLabel(0)
			e5:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e5:SetTarget(c500.valcon)
			tc:RegisterEffect(e5)
			local e6=Effect.CreateEffect(tc)
			e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_TO_GRAVE)
			e6:SetLabelObject(e5)
			e6:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e6:SetOperation(c500.reset)
			tc:RegisterEffect(e6)
			local e7=e6:Clone()
			e7:SetCode(EVENT_TO_DECK)
			tc:RegisterEffect(e7)
			local e8=e6:Clone()
			e8:SetCode(EVENT_REMOVE)
			tc:RegisterEffect(e8)
			tc:RegisterFlagEffect(500,RESET_EVENT+EVENT_ADJUST,0,1)
		end
		tc=g:GetNext()
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
function c500.sptfilter1(c,tp,djn,f)
	return c:IsFaceup() and c:GetLevel()>0 and (not f or f(c)) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c500.sptfilter2,tp,LOCATION_MZONE,0,1,c,djn,f,c:GetAttribute(),c:GetRace(),c:GetLevel())
end
function c500.sptafilter(c,alterf)
	return c:IsFaceup() and alterf(c) and c:IsAbleToRemove()
end
function c500.sptfilter2(c,djn,f,at,rc,lv)
	return c:IsFaceup() and c:GetAttribute()==at and c:GetRace()==rc
		and c:GetLevel()>0 and (djn==lv or djn==c:GetLevel())
		and (not f or f(c)) and c:IsAbleToRemove()
end
function c500.sptcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local rt=1
	if c.alterct then rt=c.alterct end
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	e:SetLabelObject(mg)
	if ct<1 and c.alterf and mg:IsExists(c500.sptafilter,1,nil,c.alterf)
		and (not c.alterop or c.alterop(e,tp,0)) then
		return true
	end
	return ct<rt and mg:IsExists(c500.sptfilter1,1,nil,tp,c:GetRank(),c.material)
end
function c500.sptop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local rt=1
	if c.alterct then rt=c.alterct end
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	e:SetLabelObject(mg)
	local b1=ct<rt and mg:IsExists(c500.sptfilter1,1,nil,tp,c:GetRank(),c.material)
	local b2=ct<1 and c.alterf and mg:IsExists(c500.sptafilter,1,nil,c.alterf)
		and (not c.alterop or c.alterop(e,tp,0))
	if b2 and (not b1 or (c.altero and Duel.SelectYesNo(tp,c.altdesc))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		mg=mg:FilterSelect(tp,c500.sptafilter,1,1,nil,c.alterf)
		e:SetLabelObject(mg)
		if c.alterop then local mc=c.alterop(e,tp,1) if mc~=nil then mg:AddCard(mc) end end
		c:SetMaterial(mg)
		Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+0x400000)
	else
		local x=c:GetRank()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local m1=mg:FilterSelect(tp,c500.sptfilter1,1,1,nil,tp,x,c.material)
		local tc=m1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local m2=mg:FilterSelect(tp,c500.sptfilter2,1,1,tc,x,c.material,tc:GetAttribute(),tc:GetRace(),tc:GetLevel())
		m1:Merge(m2)
		mg=m1
		c:SetMaterial(mg)
		Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+0x400000)
	end
end
function c500.valcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local n=1
		if c:GetRank()>4 then n=n+1 end
		if c:GetRank()>6 then n=n+1 end
		if c.dimension_loss then n=c.dimension_loss end
		return n>e:GetLabel()
	end
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	e:SetLabel(e:GetLabel()+1)
	return true
end
function c500.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
