--created by LionHeartKIng
--coded by Lyris
--Aquarium Mermaid of Stellar Vine
function c101020020.initial_effect(c)
	--If this card is Normal or Special Summoned: You can add 1 "Stellar Vine" from your Deck to your hand, except "Aquarium Mermaid of Stellar Vine".
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101020020)
	e2:SetTarget(c101020020.tg2)
	e2:SetOperation(c101020020.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--If this card is banished: You can banish 1 random card from your opponent's hand, face-down, and if you do, draw 1 card.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101020020+100000000)
	e1:SetTarget(c101020020.tg)
	e1:SetOperation(c101020020.op)
	c:RegisterEffect(e1)
end
function c101020020.filter2(c)
	return c:IsSetCard(0x785e) and c:GetCode()~=101020020 and c:IsAbleToHand()
end
function c101020020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020020.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020020.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101020020.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101020020.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101020020.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:RandomSelect(tp,1)
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	if tc:IsLocation(LOCATION_REMOVED) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
