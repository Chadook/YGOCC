--Nihlah, Shaderune Servant
function c6666676.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6666676,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c6666676.thtg)
	e1:SetOperation(c6666676.thop)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666676,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,6666676)
	e2:SetCondition(c6666676.discon)
	e2:SetTarget(c6666676.distg)
	e2:SetOperation(c6666676.disop)
	c:RegisterEffect(e2)
	--banish deck check
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6666676,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c6666676.condition)
	e3:SetTarget(c6666676.btarget)
	e3:SetOperation(c6666676.boperation)
	c:RegisterEffect(e3)
end
function c6666676.cfilter(c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function c6666676.thfilter(c,lv)
	return c:IsLevelBelow(lv) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c6666676.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c6666676.cfilter,tp,LOCATION_REMOVED,0,nil)
		local ct=g:GetClassCount(Card.GetCode)
		return Duel.IsExistingMatchingCard(c6666676.thfilter,tp,LOCATION_DECK,0,1,nil,ct)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6666676.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6666676.cfilter,tp,LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c6666676.thfilter,tp,LOCATION_DECK,0,1,1,nil,ct)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c6666676.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND)
end
function c6666676.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c6666676.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c6666676.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c6666676.btarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function c6666676.cfilter(c)
	return c:IsSetCard(0x900) or c:IsSetCard(0x901)
end
function c6666676.boperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2)
	if g:GetCount()>0 then
		local sg=g:Filter(c6666676.cfilter,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsAbleToRemove() then
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
