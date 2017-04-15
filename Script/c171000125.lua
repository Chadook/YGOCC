--Impure Amethyst
local ref=_G['c'..171000125]
function c171000125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,171000125+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
function ref.filter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return 
		(g:GetCount()>0 and Duel.IsExistingMatchingCard(ref.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil))
		or (g:GetCount()==2 and Duel.IsExistingMatchingCard(ref.thfilter2,tp,LOCATION_GRAVE,0,1,nil))
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,0)
end
function ref.thfilter1(c)
	return c:IsSetCard(0xfef) and c:IsType(TYPE_MONSTER)
	and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
	and c:IsAbleToHand()
end
function ref.thfilter2(c)
	return c:IsType(TYPE_SPELL) and not c:IsCode(171000125) and c:IsAbleToHand()
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_SZONE,0,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup():Filter(Card.IsSetCard,nil,0xfef)
	local ct=dg:GetCount()
	local opt=0
	if ct==2 and Duel.IsExistingMatchingCard(ref.thfilter2,tp,LOCATION_GRAVE,0,1,nil) then
		opt = Duel.SelectOption(tp,aux.Stringid(171000125,0),aux.Stringid(171000125,1))
	else
		if ct==1 or ct>2 then
		opt = 0
		else return end
	end
	if opt==0 and Duel.IsExistingMatchingCard(ref.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then
		local sg=Duel.SelectMatchingCard(tp,ref.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	if opt==1 and Duel.IsExistingMatchingCard(ref.thfilter2,tp,LOCATION_GRAVE,0,1,nil) then
		local sg=Duel.SelectMatchingCard(tp,ref.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
