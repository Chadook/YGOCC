--created & coded by Lyris
--剣主 五
function c101010255.initial_effect(c)
--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c101010255.val)
	c:RegisterEffect(e1)
	--xyz effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,101010255)
	e2:SetCondition(c101010255.xyzcon)
	e2:SetTarget(c101010255.xyztg)
	e2:SetOperation(c101010255.xyzop)
	c:RegisterEffect(e2)
end
function c101010255.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c101010255.val(e,c)
	return Duel.GetMatchingGroupCount(c101010255.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,c)*100
end
function c101010255.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and ph>=0x8 and ph<=0x80
end
function c101010255.mfilter(c)
	return c:IsSetCard(0xbb2) and c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c101010255.xyzfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR) and c:IsXyzSummonable(mg)
end
function c101010255.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c101010255.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c101010255.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010255.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010255.mfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c101010255.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,sg,1,5)
		local tc=xyz
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
