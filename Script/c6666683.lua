--Pomegranate of the Shaderune Queen
function c6666683.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c6666683.cost)
	e1:SetTarget(c6666683.target)
	e1:SetOperation(c6666683.activate)
	c:RegisterEffect(e1)
	--Add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666683,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c6666683.condtion)
	e2:SetTarget(c6666683.target)
	e2:SetOperation(c6666683.activate)
	c:RegisterEffect(e2)
end
function c6666683.condtion(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c6666683.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,3,nil) end
    local g=Duel.GetDecktopGroup(tp,3)
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c6666683.filter(c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c6666683.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6666683.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6666683.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6666683.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end