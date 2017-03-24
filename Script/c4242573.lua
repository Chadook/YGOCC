--Moon's Clouds to Hide
function c4242573.initial_effect(c)

--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242564,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4242573+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c4242573.activate)
	c:RegisterEffect(e1)
--Can't target scales
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(c4242573.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end

--Can't Target scales code
function c4242573.tgtg(e,c)
	return (c:IsSetCard(0x666))
		and (c:GetSequence()==6 or c:GetSequence()==7)
end
--Activation code
function c4242573.thfilter(c)
	return c:IsSetCard(0x666) and c:IsLevelBelow(4) and c:IsAbleToHand()
end

function c4242573.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c4242573.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(4242573,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end






