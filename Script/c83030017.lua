--Carefree Journey
function c83030017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,83030017+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c83030017.target)
	e1:SetOperation(c83030017.activate)
	c:RegisterEffect(e1)
end
function c83030017.filter(c,e,tp)
	return c:IsSetCard(0x833) and c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c83030017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c83030017.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c83030017.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c83030017.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	local pos
	if tc:GetAttack()>tc:GetDefense() then pos=POS_FACEUP_ATTACK
	else pos=POS_FACEUP_DEFENSE end
	if tc and Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,pos) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x10001)
		e1:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
