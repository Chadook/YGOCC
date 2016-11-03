--Stymphal Crosswind
function c11263.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCondition(c11263.tokencon)
	e1:SetOperation(c11263.tokenop)
	c:RegisterEffect(e1)
end
function c11263.tokencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11264,0,0x4011,1000,1000,1,RACE_WINDBEAST,ATTRIBUTE_WIND)
end
function c11263.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) or not re:GetHandler():IsSetCard(0x2BF2) or not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	local token=Duel.CreateToken(tp,11264)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
