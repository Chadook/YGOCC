--created by Chadook, coded by Michael Lawrence Dee & Lyris
--エーボルート召喚
function c388.initial_effect(c)
	if not c388.global_check then
		c388.global_check=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c388.op)
		Duel.RegisterEffect(e2,0)
	end
end
function c388.filterx(c)
	return c.evolute
end
function c388.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c388.filterx,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(388)==0 then
			if not tc.relay then tc:SetStatus(STATUS_NO_LEVEL,true) end
			local e0=Effect.CreateEffect(tc)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e0:SetCode(EFFECT_SPSUMMON_CONDITION)
			if tc.evolute_only then
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			else
				e0:SetRange(LOCATION_EXTRA)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
			end
			e0:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e0:SetValue(function(e,se,sp,st) return bit.band(st,388)==388 end)
			tc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetDescription(aux.Stringid(388,0))
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(388)
			e1:SetCondition(c388.sumcon)
			e1:SetOperation(c388.sumop)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCondition(c388.addcon)
			e2:SetOperation(c388.addc)
			e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_REMOVE_TYPE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e3:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e3:SetValue(TYPE_XYZ)
			tc:RegisterEffect(e3)
			tc:RegisterFlagEffect(388,RESET_EVENT+EVENT_ADJUST,0,1)  
		end
		tc=g:GetNext()
	end
	if Duel.GetFlagEffect(0,47594939)==0 and Duel.IsExistingMatchingCard(c388.nlrfilter,tp,0xff,0xff,1,nil) then
		local g=Duel.GetMatchingGroup(c388.amafilter,tp,0xdf,0xdf,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoDeck(g,nil,-2,REASON_RULE)
		Duel.RegisterFlagEffect(0,47594939,0,0,1)
	end
end
function c388.amafilter(c)
	return c:GetOriginalCode()==47594939
end
function c388.nlrfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsStatus(STATUS_NO_LEVEL)
end
function c388.matfilter1(c,evo,tp)
	local mg2=Duel.GetMatchingGroup(c388.matfilter2,tp,LOCATION_MZONE,0,c,evo)
	return evo.material1 and evo.material1(c)
		and mg2:GetCount()>0
end
function c388.matfilter2(c,evo)
	return evo.material2 and evo.material2(c)
end
function c388.sumcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg1=Duel.GetMatchingGroup(c388.matfilter1,tp,LOCATION_MZONE,0,nil,c,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg1:GetCount()>0
end
function c388.sumop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg1=Duel.GetMatchingGroup(c388.matfilter1,tp,LOCATION_MZONE,0,nil,c,tp)
	local mg2=Duel.GetMatchingGroup(c388.matfilter2,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(388,1))
	local sg1=mg1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(388,1))
	local sg2=mg2:Select(tp,1,1,sg1:GetFirst())
	sg1:Merge(sg2)
	c:SetMaterial(sg1)
	Duel.SendtoGrave(sg1,REASON_MATERIAL+0x10000000)
end
function c388.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c388.addc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1088,c388.read_stage(e:GetHandler()))
end
function c388.read_stage(c)
	local m=_G["c"..c:GetOriginalCode()]
	if not m then return false end
	return m.stage_o
end
