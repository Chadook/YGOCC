--Primal Procedure
function c550.initial_effect(c)
	if not c550.global_check then
		c550.global_check=true
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c550.op)
		Duel.RegisterEffect(e2,0)
	end
end
function c550.filterx(c)
	return c.primal
end
function c550.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c550.filterx,0,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_DECK) then Duel.DisableShuffleCheck() Duel.SendtoGrave(tc,nil,REASON_RULE) end
		if tc:IsLocation(LOCATION_HAND) then Duel.SendtoGrave(tc,nil,0,REASON_RULE) Duel.Draw(tp,1,REASON_RULE) end
		if tc:GetFlagEffect(550)==0 then
			tc:EnableReviveLimit()
			local e0=Effect.CreateEffect(tc)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_SPSUMMON_CONDITION)
			if not tc.primal_nomi then
				e0:SetRange(LOCATION_EXTRA)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
			else
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			end
			e0:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e0:SetValue(c550.splimit)
			tc:RegisterEffect(e0)
			if not primal_track then
				primal_track=true
				local e1p=Effect.CreateEffect(tc)
				e1p:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1p:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
				--e1p:SetCountLimit(1)
				e1p:SetOperation(c550.count)
				Duel.RegisterEffect(e1p,0)
			end
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetCondition(c550.spcon)
			e1:SetOperation(c550.spop)
			e1:SetValue(0x5500)
			e1:SetCountLimit(1,0x5500)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e2:SetValue(TYPE_SYNCHRO)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(550,RESET_EVENT+EVENT_ADJUST,0,1)
		end
		tc=g:GetNext()
	end
end
function c550.splimit(e,se,sp,st)
	return bit.band(st,0x5500)==0x5500
end
--Primal Summon by sending 1 monster on the field who has been on the field during 1 or more Battle Phases to the graveyard to summon a primal monster whose prime level equals the sent monsters level + the number of battle phases it has been through on the field.
function c550.count(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetOwner():GetOwner()
	local g=Duel.GetFieldGroup(p,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	local ct
	while tc do
		ct=tc:GetFlagEffectLabel(55006000)
		if not ct then
			tc:RegisterFlagEffect(55006000,RESET_EVENT+0x1fc0000,0,1,1)
		else
			tc:SetFlagEffectLabel(55006000,ct+1)
		end
		tc=g:GetNext()
	end
end
function c550.matfilter(c,x,f)
	return c:IsFaceup() and c:GetFlagEffect(55006000)>0 and c:GetLevel()+c:GetFlagEffectLabel(55006000)==x and (not f or f(c))
		and c:IsAbleToGrave()
end
function c550.spcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ct=1
	if c.material_mincount then ct=c.material_mincount end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-ct and Duel.IsExistingMatchingCard(c550.matfilter,tp,LOCATION_MZONE,0,ct,nil,c:GetLevel(),c.material)
end
function c550.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local min=1
	if c.material_mincount then min=c.material_mincount end
	local max=min
	if c.material_maxcount then max=c.material_maxcount end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c550.matfilter,tp,LOCATION_MZONE,0,min,max,nil,c:GetLevel(),c.material)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x550000)
end
