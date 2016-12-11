--created & coded by Lyris
--Blade's Oath
function c101010301.initial_effect(c)
--Special Summon 1 "Blademaster" monster attached to an Xyz Monster you control. You can only activate 1 "Blade's Oath" per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,101010301+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c101010301.tg2)
	e2:SetOperation(c101010301.op2)
	c:RegisterEffect(e2)
end
function c101010301.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(c101010301.filter,1,nil,e,tp)
end
function c101010301.filter(c,e,tp)
	return c:IsSetCard(0xbb2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010301.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010301.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c101010301.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local xg=Duel.GetMatchingGroup(c101010301.spfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	local tc=xg:GetFirst()
	while tc do
		g:Merge(tc:GetOverlayGroup())
		tc=xg:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,c101010301.filter,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
